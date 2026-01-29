local Combinators = {}

function Combinators.create_for_struct(struct)
  struct.proxy_container_a = storage.surface.create_entity{
    name = "proxy-container",
    force = "neutral",
    position = {0.5 + struct.index, -0.5},
  }
  struct.proxy_container_a.proxy_target_entity = struct.container
  struct.proxy_container_a.proxy_target_inventory = defines.inventory.chest

  struct.proxy_container_b = storage.surface.create_entity{
    name = "proxy-container",
    force = "neutral",
    position = {0.5 + struct.index, -1.5},
  }
  struct.proxy_container_b.proxy_target_entity = struct.entity
  struct.proxy_container_b.proxy_target_inventory = defines.inventory.crafter_modules

  struct.arithmetic_1 = storage.surface.create_entity{
    name = "arithmetic-combinator",
    force = "neutral",
    position = {0.5 + struct.index, -3.0},
    direction = defines.direction.north,
  }
  assert(struct.arithmetic_1)
  arithmetic_1_cb = struct.arithmetic_1.get_control_behavior() --[[@as LuaArithmeticCombinatorControlBehavior]]
  arithmetic_1_cb.parameters = {
    first_signal = {
      type = "virtual",
      name = "signal-each"
    },
    second_constant = 0,
    operation = "+",
    output_signal = {
      type = "virtual",
      name = "signal-each"
    },
    first_signal_networks = {
      red = true,
      green = true
    },
    second_signal_networks = {
      red = true,
      green = true
    }
  }

  struct.arithmetic_2 = storage.surface.create_entity{
    name = "arithmetic-combinator",
    force = "neutral",
    position = {0.5 + struct.index, -5.0},
    direction = defines.direction.north,
  }
  assert(struct.arithmetic_2)
  arithmetic_2_cb = struct.arithmetic_2.get_control_behavior() --[[@as LuaArithmeticCombinatorControlBehavior]]
  arithmetic_2_cb.parameters = {
    first_signal = {
      type = "virtual",
      name = "signal-each"
    },
    second_signal = {
      type = "virtual",
      name = "signal-each"
    },
    operation = "-",
    output_signal = {
      type = "virtual",
      name = "signal-each"
    },
    first_signal_networks = {
      red = true,
      green = false
    },
    second_signal_networks = {
      red = false,
      green = true
    }
  }

  do -- connect proxy container a to arithmetic combinator 1 & 2
    local red_out = struct.proxy_container_a.get_wire_connector(defines.wire_connector_id.circuit_red, true) --[[@as LuaWireConnector]]
    local red_in1 = struct.arithmetic_1.get_wire_connector(defines.wire_connector_id.combinator_input_red, false) --[[@as LuaWireConnector]]
    local red_in2 = struct.arithmetic_2.get_wire_connector(defines.wire_connector_id.combinator_input_red, false) --[[@as LuaWireConnector]]
    assert(red_out.connect_to(red_in1, false, defines.wire_origin.player))
    assert(red_out.connect_to(red_in2, false, defines.wire_origin.player))
  end
  do -- connect proxy container b to arithmetic combinator 1 & 2
    local red_out = struct.proxy_container_b.get_wire_connector(defines.wire_connector_id.circuit_red, true) --[[@as LuaWireConnector]]
    local red_in1 = struct.arithmetic_1.get_wire_connector(defines.wire_connector_id.combinator_input_red, false) --[[@as LuaWireConnector]]
    local red_in2 = struct.arithmetic_2.get_wire_connector(defines.wire_connector_id.combinator_input_red, false) --[[@as LuaWireConnector]]
    assert(red_out.connect_to(red_in1, false, defines.wire_origin.player))
    assert(red_out.connect_to(red_in2, false, defines.wire_origin.player))
  end

  do
    local green_out = struct.arithmetic_1.get_wire_connector(defines.wire_connector_id.combinator_output_green, false) --[[@as LuaWireConnector]]
    local green_in = struct.arithmetic_2.get_wire_connector(defines.wire_connector_id.combinator_input_green, false) --[[@as LuaWireConnector]]
    assert(green_out.connect_to(green_in, false, defines.wire_origin.player))
  end

  struct.inserter_1 = storage.surface.create_entity{
    name = "inserter",
    force = "neutral",
    position = {0.5 + struct.index, -7.5},
    direction = defines.direction.south,
  }
  assert(struct.inserter_1)
  inserter_1_cb = struct.inserter_1.get_or_create_control_behavior() --[[@as LuaInserterControlBehavior]]
  inserter_1_cb.circuit_enable_disable = true
  inserter_1_cb.circuit_condition = {
    first_signal = {
      type = "virtual",
      name = "signal-anything"
    },
    constant = 0,
    comparator = "≠",
    fulfilled = false
  }

  do
    local red_out = struct.arithmetic_2.get_wire_connector(defines.wire_connector_id.combinator_output_red, false) --[[@as LuaWireConnector]]
    local red_in = struct.inserter_1.get_wire_connector(defines.wire_connector_id.circuit_red, false) --[[@as LuaWireConnector]]
    assert(red_out.connect_to(red_in, false, defines.wire_origin.player))
  end

  local entity_cb = struct.entity.get_or_create_control_behavior() --[[@as LuaAssemblingMachineControlBehavior]]
  entity_cb.circuit_read_recipe_finished = true
  entity_cb.circuit_recipe_finished_signal = {type = "virtual", name = "signal-F"}

  struct.inserter_2 = storage.surface.create_entity{
    name = "inserter",
    force = "neutral",
    position = {0.5 + struct.index, -9.5},
    direction = defines.direction.south,
  }
  assert(struct.inserter_2)
  inserter_2_cb = struct.inserter_2.get_or_create_control_behavior() --[[@as LuaInserterControlBehavior]]
  inserter_2_cb.circuit_enable_disable = true
  inserter_2_cb.circuit_condition = {
    first_signal = {
      type = "virtual",
      name = "signal-F"
    },
    constant = 0,
    comparator = ">",
    fulfilled = false
  }

  do
    local red_out = struct.entity.get_wire_connector(defines.wire_connector_id.circuit_red, false) --[[@as LuaWireConnector]]
    local red_in = struct.inserter_2.get_wire_connector(defines.wire_connector_id.circuit_red, false) --[[@as LuaWireConnector]]
    assert(red_out.connect_to(red_in, false, defines.wire_origin.player))
  end

  -- Decider combinator to detect empty inventory during crafting
  struct.decider_1 = storage.surface.create_entity{
    name = "decider-combinator",
    force = "neutral",
    position = {0.5 + struct.index, -11.0},
    direction = defines.direction.north,
  }
  assert(struct.decider_1)
  decider_1_cb = struct.decider_1.get_control_behavior() --[[@as LuaDeciderCombinatorControlBehavior]]
  decider_1_cb.parameters = {
    first_signal = {
      type = "virtual",
      name = "signal-anything"
    },
    second_constant = 0,
    comparator = "=",
    output_signal = {
      type = "virtual",
      name = "signal-E"
    },
    copy_count_from_input = false,
    first_signal_networks = {
      red = true,
      green = false
    }
  }

  do -- connect proxy_container_a and entity to decider_1 input
    local red_out_container = struct.proxy_container_a.get_wire_connector(defines.wire_connector_id.circuit_red, true) --[[@as LuaWireConnector]]
    local red_out_entity = struct.entity.get_wire_connector(defines.wire_connector_id.circuit_red, false) --[[@as LuaWireConnector]]
    local red_in = struct.decider_1.get_wire_connector(defines.wire_connector_id.combinator_input_red, false) --[[@as LuaWireConnector]]
    assert(red_out_container.connect_to(red_in, false, defines.wire_origin.player))
    assert(red_out_entity.connect_to(red_in, false, defines.wire_origin.player))
  end

  struct.inserter_3 = storage.surface.create_entity{
    name = "inserter",
    force = "neutral",
    position = {0.5 + struct.index, -13.5},
    direction = defines.direction.south,
  }
  assert(struct.inserter_3)
  inserter_3_cb = struct.inserter_3.get_or_create_control_behavior() --[[@as LuaInserterControlBehavior]]
  inserter_3_cb.circuit_enable_disable = true
  inserter_3_cb.circuit_condition = {
    first_signal = {
      type = "virtual",
      name = "signal-E"
    },
    second_signal = {
      type = "virtual",
      name = "signal-C"
    },
    comparator = "AND",
    fulfilled = false
  }

  do
    local red_out = struct.decider_1.get_wire_connector(defines.wire_connector_id.combinator_output_red, false) --[[@as LuaWireConnector]]
    local red_in = struct.inserter_3.get_wire_connector(defines.wire_connector_id.circuit_red, false) --[[@as LuaWireConnector]]
    assert(red_out.connect_to(red_in, false, defines.wire_origin.player))
  end
end

return Combinators
