package main

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"os/signal"
	"strconv"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/konstellation-io/kai-sdk/go-sdk/v2/runner"
	"github.com/konstellation-io/kai-sdk/go-sdk/v2/runner/trigger"
	"github.com/konstellation-io/kai-sdk/go-sdk/v2/sdk"
	centralizedConfiguration "github.com/konstellation-io/kai-sdk/go-sdk/v2/sdk/centralized-configuration"
	"google.golang.org/protobuf/types/known/anypb"
	"google.golang.org/protobuf/types/known/structpb"
)

var path = "/trigger"

func main() {
	runner.
		NewRunner().
		TriggerRunner().
		WithInitializer(restInitializer).
		WithRunner(restServerRunner).
		Run()
}

func restInitializer(kaiSDK sdk.KaiSDK) {
	kaiSDK.Logger.Info("Initializer, loading config")
	pathConfig, err := kaiSDK.CentralizedConfig.GetConfig("path", centralizedConfiguration.ProcessScope)
	if err == nil {
		kaiSDK.Logger.Info("Initializer, config loaded", "path", pathConfig)
		path = pathConfig
	}
}

func restServerRunner(tr *trigger.Runner, kaiSDK sdk.KaiSDK) {
	kaiSDK.Logger.Info("Starting http server", "port", 8080)

	bgCtx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	r := gin.Default()
	r.GET(path, getHandler(kaiSDK, tr.GetResponseChannel))
	r.POST(path, postHandler(kaiSDK, tr.GetResponseChannel))
	r.PUT(path, putHandler(kaiSDK, tr.GetResponseChannel))
	r.DELETE(path, deleteHandler(kaiSDK, tr.GetResponseChannel))

	srv := &http.Server{
		Addr:    ":8080",
		Handler: r,
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			kaiSDK.Logger.Error(err, "Error running http server")
		}
	}()

	<-bgCtx.Done()
	stop()
	kaiSDK.Logger.Info("Shutting down server...")

	// The kaiSDK is used to inform the server it has 5 seconds to finish
	// the request it is currently handling
	bgCtx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(bgCtx); err != nil {
		kaiSDK.Logger.Error(err, "Error shutting down server")
	}

	kaiSDK.Logger.Info("Server stopped")
}

func postHandler(kaiSDK sdk.KaiSDK, getResponseChannel func(requestID string) <-chan *anypb.Any) func(c *gin.Context) {
	return responseHandler(kaiSDK, getResponseChannel, "POST")
}

func putHandler(kaiSDK sdk.KaiSDK, getResponseChannel func(requestID string) <-chan *anypb.Any) func(c *gin.Context) {
	return responseHandler(kaiSDK, getResponseChannel, "PUT")
}

func getHandler(kaiSDK sdk.KaiSDK, getResponseChannel func(requestID string) <-chan *anypb.Any) func(c *gin.Context) {
	return responseHandler(kaiSDK, getResponseChannel, "GET")
}

func deleteHandler(kaiSDK sdk.KaiSDK, getResponseChannel func(requestID string) <-chan *anypb.Any) func(c *gin.Context) {
	return responseHandler(kaiSDK, getResponseChannel, "DELETE")
}

func responseHandler(kaiSDK sdk.KaiSDK, getResponseChannel func(requestID string) <-chan *anypb.Any, restMethod string) func(c *gin.Context) {
	return func(c *gin.Context) {

		reqID := uuid.New().String()
		kaiSDK.Logger.Info("REST triggered, sending message", "requestID", reqID)

		m, err := prepareMessageOutput(restMethod, c.Request.Body)
		if err != nil {
			kaiSDK.Logger.Error(err, "error preparing message output")
			return
		}

		err = kaiSDK.Messaging.SendOutputWithRequestID(m, reqID)
		if err != nil {
			kaiSDK.Logger.Error(err, "Error sending output")
			return
		}

		responseChannel := getResponseChannel(reqID)
		response := <-responseChannel

		kaiSDK.Logger.Info("response recieved", "response", response)

		httpCode, respessage, err := unmarshalResponse(response)
		if err != nil {
			kaiSDK.Logger.Error(err, "error unmarshalling response")
			return
		}

		c.JSON(httpCode, gin.H{
			"message": respessage,
		})
	}
}

func unmarshalResponse(response *anypb.Any) (int, string, error) {
	var respData struct {
		StatusCode string `json:"status_code"`
		Message    string `json:"message"`
	}

	responsePb := new(structpb.Value)

	err := response.UnmarshalTo(responsePb)
	if err != nil {
		return 0, "", err
	}

	responsePbJSON, err := responsePb.MarshalJSON()
	if err != nil {
		return 0, "", err
	}

	err = json.Unmarshal(responsePbJSON, &respData)
	if err != nil {
		return 0, "", err
	}

	httpCode, err := strconv.Atoi(respData.StatusCode)
	if err != nil {
		return 0, "", err
	}

	return httpCode, respData.Message, nil
}

func prepareMessageOutput(restMethod string, body io.ReadCloser) (*structpb.Value, error) {
	var m *structpb.Value
	var err error

	if restMethod == "POST" || restMethod == "PUT" {
		jsonData, err := io.ReadAll(body)
		if err != nil {
			return nil, err
		}

		m, err = structpb.NewValue(map[string]interface{}{
			"method": restMethod,
			"body":   jsonData,
		})
		if err != nil {
			return nil, err
		}
	} else {
		m, err = structpb.NewValue(map[string]interface{}{
			"method": restMethod,
		})
		if err != nil {
			return nil, err
		}
	}

	return m, nil
}
