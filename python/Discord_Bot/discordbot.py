import hikari

bot = hikari.GatewayBot(token='OTU0MzkxNjAyNTM1NzQ3NjU0.YjSccQ.X3AHEct62oWUOm1XPmVkYSG7cSg')

@bot.listen(hikari.GuildMessageCreateEvent)
async def print_message(event):
    print(event.content)

@bot.listen(hikari.StartedEvent)
async def bot_started(event):
    print('Bot has started!')

bot.run()