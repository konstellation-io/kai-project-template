import asyncio
from sdk.kai_sdk import KaiSDK
from runner.runner import Runner
from google.protobuf.any_pb2 import Any
from google.protobuf.struct_pb2 import Value


async def initializer(sdk: KaiSDK):
    sdk.logger.info("Initializing training process")


async def handler(sdk: KaiSDK, message: Any):
    sdk.logger.info(f"Received message in training: {message}")
    response = Value()
    response.struct_value.fields["status_code"].string_value = "200"
    response.struct_value.fields[
        "message"
    ].string_value = "Training completed successfully"
    await sdk.messaging.send_output(response=response)


async def finalizer(sdk: KaiSDK):
    sdk.logger.info("Finalizing training process")


async def init():
    runner = await Runner().initialize()
    await (
        runner.exit_runner()
        .with_initializer(initializer)
        .with_handler(handler)
        .with_finalizer(finalizer)
        .run()
    )


if __name__ == "__main__":
    loop = asyncio.new_event_loop()
    loop.run_until_complete(init())
    loop.run_forever()
    loop.close()
