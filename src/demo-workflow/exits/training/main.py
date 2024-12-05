import asyncio
from sdk import kai_sdk
from runner import runner as Runner


async def initializer(sdk: kai_sdk):
    pass


async def handler(sdk: kai_sdk):
    pass


async def finalizer(sdk: kai_sdk):
    pass


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
