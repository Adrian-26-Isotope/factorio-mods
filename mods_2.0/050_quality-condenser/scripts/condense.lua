local Condense = {}

local get_next_quality_name = {} -- next_quality_name["normal"] = "uncommon"
local get_next_probability = {}

for _, quality in pairs(prototypes.quality) do
  if quality.next then
    get_next_quality_name[quality.name] = quality.next.name
  end
  get_next_probability[quality.name] = quality.next_probability
end

local get_recreate_probability = {
  [0] = 0.25,  -- normal
  [1] = 0.28,  -- uncommon
  [2] = 0.33,  -- rare
  [3] = 0.40,  -- epic
  [4] = 0.50,  -- unused
  [5] = 0.50,  -- legendary
}

-- log(serpent.block(next_quality_name))

local item_can_spoil = {}
for _, item in pairs(prototypes.item) do
  if item.get_spoil_ticks() > 0 then
    item_can_spoil[item.name] = true
  end
end

local function get_spoil_percentage(inventory, item)
  local spoil_percentage = nil

  for slot = 1, #inventory do
    local stack = inventory[slot]
    if stack.valid_for_read and stack.name == item.name and stack.quality.name == item.quality then
      if spoil_percentage == nil then
        spoil_percentage = stack.spoil_percent
      else
        spoil_percentage = (spoil_percentage + stack.spoil_percent) / 2
      end
    end
  end

  return spoil_percentage
end

local function set_idle_status(struct)
  struct.entity.disabled_by_script = true
  struct.entity.custom_status = {
    diode = defines.entity_status_diode.yellow,
    label = {"entity-status.sleeping"},
  }
  enable_wake_on_input(struct)
end

helpers.write_file("quality-condenser.log", "", false, nil)

local function calculate_recreated_count(item_count, probability)
  local recreated = 0
  for i = 1, item_count do
    if math.random() < probability then
      recreated = recreated + 1
    end
  end
  return recreated
end

local function roll_quality_upgrade(start_quality_name, quality_effect, force)
  local current_quality_name = start_quality_name

  while true do
    local next_quality_name = get_next_quality_name[current_quality_name]
    if not next_quality_name then break end

    local quality_proto = prototypes.quality[next_quality_name]
    if not quality_proto or not force.is_quality_unlocked(quality_proto) then break end

    local next_probability = get_next_probability[current_quality_name]
    local upgrade_chance = (quality_effect * next_probability) / 1000

    if math.random() < upgrade_chance then
      current_quality_name = next_quality_name
    else
      break
    end
  end

  return current_quality_name
end

function Condense.trigger(struct)
  local quality_effect = (struct.entity.effects["quality"] or 0) * 1000
  
  -- Get condenser's quality level for re-creation probability
  local condenser_quality = struct.entity.quality.level
  local recreate_probability = get_recreate_probability[condenser_quality] or 0.25
  
  local anything_happened = false
  
  -- Track items to insert by quality and spoilage
  local items_to_insert = {}
  
  for _, item in ipairs(struct.container_inventory.get_contents()) do
    -- Calculate how many items are re-created
    local recreated_count = calculate_recreated_count(item.count, recreate_probability)
    
    if recreated_count > 0 then
      -- Roll quality upgrades for each re-created item
      for i = 1, recreated_count do
        local final_quality_name = item.quality
        
        -- Only attempt quality upgrades if quality_effect > 0
        if quality_effect > 0 then
          final_quality_name = roll_quality_upgrade(item.quality, quality_effect, struct.entity.force)
        end
        
        -- Create key for grouping items by quality and spoilage
        local key = item.name .. "|" .. final_quality_name
        
        if item_can_spoil[item.name] then
          local spoil_percent = assert(get_spoil_percentage(struct.container_inventory, item))
          key = key .. "|" .. tostring(spoil_percent)
          
          if not items_to_insert[key] then
            items_to_insert[key] = {
              name = item.name,
              quality = final_quality_name,
              count = 0,
              spoil_percent = spoil_percent
            }
          end
        else
          if not items_to_insert[key] then
            items_to_insert[key] = {
              name = item.name,
              quality = final_quality_name,
              count = 0
            }
          end
        end
        
        items_to_insert[key].count = items_to_insert[key].count + 1
      end
      
      anything_happened = true
    end
    
    -- Remove all original items
    assert(struct.container_inventory.remove(item) == item.count)
  end
  
  -- Insert all re-created items
  for _, to_insert in pairs(items_to_insert) do
    local inserted = struct.container_inventory.insert(to_insert)
    if inserted ~= to_insert.count then
      struct.container_inventory.sort_and_merge()
      to_insert.count = to_insert.count - inserted
      inserted = struct.container_inventory.insert(to_insert)
      assert(inserted == to_insert.count, string.format("inserted only %d of %d %s (%s)", inserted, to_insert.count, to_insert.name, to_insert.quality))
    end
  end
  
  -- Sort and merge at the end if anything happened
  if anything_happened then
    struct.container_inventory.sort_and_merge()
  end
  
  -- Only go idle if inventory is empty
  if struct.container_inventory.get_item_count() == 0 then
    set_idle_status(struct)
  end
end

return Condense
