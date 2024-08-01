Config = {}

Config.DiscordIntegration = false
Config.DiscordWebHook = ""
Config.DiscordBotName= "HEC Chest"
Config.DiscordAvatar = ""

Config.Chests = {
    {
        item = 'example1_chest',
        combo1 = 4,  --Numbers must be between 1 - 39
        combo2 = 12,
        combo3 = 21,
        combo4 = 36,
        itemRewards = {
            {
                itemName = "example_item1",
                amount = 5
            },
            {
                itemName = "example_item2",
                amount = 5
            },
            {
                itemName = "example_item3",
                amount = 10
            },
        },  --set to false if no item rewards
        cashReward = 500,  --set to false if no cash reward
    },
}
