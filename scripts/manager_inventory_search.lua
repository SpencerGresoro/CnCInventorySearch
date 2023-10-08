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
                        ['staff'] = true,
                        ['bonus'] = true,
                        ['curse'] = true,
                        ['charge'] = true
                    };

                    -- check type and subtype for partial match of keywords
                    local bIsMagic = false;
                    for key, value in pairs(tMagical) do
                        if string.find(sType, key) or string.find(sSubType, key) then
                            bIsMagic = true;
                        end
                    end
                    return bIsMagic;
                end

            end
        },
        [5] = {
            sFilterValue = 'filter_charged',
            fFilter = function(item)
                local sType = DB.getValue(item, 'itemtype', ''):lower();
                return sType == 'charged';
            end
        },
        [6] = {
            sFilterValue = 'filter_id',
            fFilter = function(item)
                return (LibraryData.getIDState('item', item, true)) == true;
            end
        },
        [7] = {
            sFilterValue = 'filter_not_id',
            fFilter = function(item)
                return (LibraryData.getIDState('item', item, true)) == false;
            end
        },
        [8] = {
            sFilterValue = 'filter_gear',
            fFilter = function(item)
                -- adventure gear
                local sType = DB.getValue(item, 'itemtype', ''):lower();
                local sSubType = DB.getValue(item, 'subtype', ''):lower();
                return sType == 'adventuring gear';
            end
        },
        [9] = {
            sFilterValue = 'filter_container',
            fFilter = function(item)
                local sType = DB.getValue(item, 'itemtype', ''):lower();
                return sType == 'container';
            end
        },
        [10] = {
            sFilterValue = 'filter_carried',
            fFilter = function(item)
                return DB.getValue(item, 'carried', '') == 1;
            end
        },
        [11] = {
            sFilterValue = 'filter_equipped',
            fFilter = function(item)
                return DB.getValue(item, 'carried', '') == 2;
            end
        },
        [12] = {
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
