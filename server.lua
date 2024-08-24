ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



lib.callback.register('One-Codes:GetForTP:data', function()

    return "yes"
end)