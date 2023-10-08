-- on init - register/define filter object
function onInit()
    local ruleset = User.getRulesetName();

    -- dictionary object of which contains the correct filter callback by type
    objFilterObjects = {
        [1] = {
            sFilterValue = 'filter_none',
            fFilter = function()
                return true;
            end
        },
        [2] = {
            sFilterValue = 'filter_armor',
            fFilter = function(item)
                local sType = DB.getValue(item, 'itemtype', ''):lower();
                return sType == 'armor';
            end
        },
        [3] = {
            sFilterValue = 'filter_weapons',
            fFilter = function(item)
                local sType = DB.getValue(item, 'itemtype', ''):lower();
                return sType == 'weapon';
            end
        },
        [4] = {
            sFilterValue = 'filter_magical',
            fFilter = function(item)

                local unidentified = LibraryData.getIDState('item', item, true) == false;
                local client = Session.IsHost == false;

                -- client - dont show magic if unidentified
                if unidentified and client then
                    return false;
                else

                    -- check item type or subtype matches any of the criteria for 'magical'
                    local sType = DB.getValue(item, 'itemtype', ''):lower();
                    local sSubType = DB.getValue(item, 'subtype', ''):lower();
                    local tMagical = {
                        ['magic'] = true,
                        ['scroll'] = true,
                        ['potion'] = true,
                        ['staff'] = true
                    };

                    local bIsMagic = tMagical[sType] or tMagical[sSubType];
                    return bIsMagic;
                end

            end
        },
        [5] = {
            sFilterValue = 'filter_id',
            fFilter = function(item)
                return (LibraryData.getIDState('item', item, true)) == true;
            end
        },
        [6] = {
            sFilterValue = 'filter_not_id',
            fFilter = function(item)
                return (LibraryData.getIDState('item', item, true)) == false;
            end
        },
        [7] = {
            sFilterValue = 'filter_gear',
            fFilter = function(item)

                -- adventure gear
                local sType = DB.getValue(item, 'itemtype', ''):lower();
                local sSubType = DB.getValue(item, 'subtype', ''):lower();

                return sType == 'adventuring gear';
                -- local tGear = {
                --     ['equipment packs'] = true,
                --     ['gear'] = true,
                --     ['tool'] = true,
                --     ['clothing'] = true,
                --     ['cloak'] = true,
                --     ['container'] = true,
                --     ['provisions'] = true,
                --     ['tack and harness'] = true,
                --     ['herb or spice'] = true
                -- };

                -- -- check item type or subtype matches any of the criteria for 'adventure gear'
                -- local bIsGear = tGear[sType] or tGear[sSubType];
                -- return bIsGear;
            end
        },
        [8] = {
            sFilterValue = 'filter_goods',
            fFilter = function(item)

                -- goods, services, provisions ect.
                local sType = DB.getValue(item, 'itemtype', ''):lower();
                local sSubType = DB.getValue(item, 'subtype', ''):lower();
                local tGoodsAndServices = {
                    ['goods and services'] = true,
                    ['daily food and lodging'] = true,
                    ['service'] = true,
                    ['transport'] = true,
                    ['animal'] = true,
                    ['mounts'] = true,
                    ['vehicles'] = true
                };

                -- check item type or subtype matches any of the criteria for 'goods and services'
                local bIsGoods = tGoodsAndServices[sType] or tGoodsAndServices[sSubType];
                return bIsGoods;
            end
        },
        [9] = {
            sFilterValue = 'filter_carried',
            fFilter = function(item)
                return DB.getValue(item, 'carried', '') == 1;
            end
        },
        [10] = {
            sFilterValue = 'filter_equipped',
            fFilter = function(item)
                return DB.getValue(item, 'carried', '') == 2;
            end
        },
        [11] = {
            sFilterValue = 'filter_not_carried',
            fFilter = function(item)
                return DB.getValue(item, 'carried', '') == 0;
            end
        }
    };
end

-- dropdown - lookup the correct filter object
function lookupFilterObject(sFilterValue)
    local option;

    -- cycle, find and return object
    for _, obj in ipairs(SearchAndFilterManager.objFilterObjects) do
        if Interface.getString(obj.sFilterValue) == sFilterValue then
            option = obj;
        end
    end

    -- return the option object which contains things like the filter callback
    return option;
end
