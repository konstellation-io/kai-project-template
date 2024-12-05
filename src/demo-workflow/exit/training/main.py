import asyncio
from sdk import kai_sdk
from runner import Runner#, RunnerOptions, LoggerOptions

async def initializer():
    kai
    pass

async def handler():
    pass

async def finalizer():
    pass

async def init():
    runner = await Runner(
        options=RunnerOptions(logger_options=LoggerOptions(level="DEBUG"))
    ).initialize()
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
