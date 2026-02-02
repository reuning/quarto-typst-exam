-- Lua filter for exam extension
-- Processes custom divs (.question, .part, .subpart, .subsubpart, etc.)

local function get_attribute(el, name, default)
  local value = el.attributes[name]
  if value == nil then
    return default
  end
  return value
end

local function parse_number(str)
  if str == nil then
    return nil
  end
  local num = tonumber(str)
  return num
end

local function parse_boolean(str, default)
  if str == nil then
    return default
  end
  if str == "true" or str == "True" or str == "TRUE" then
    return true
  elseif str == "false" or str == "False" or str == "FALSE" then
    return false
  end
  return default
end

function Div(el)
  -- Question div
  if el.classes:includes("question") then
    local points = parse_number(get_attribute(el, "points"))
    local bonus = parse_boolean(get_attribute(el, "bonus"), false)
    local title = get_attribute(el, "title")
    local label = get_attribute(el, "label")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#question("))
    
    if points ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  points: " .. tostring(points) .. ","))
    end
    
    if bonus then
      table.insert(result, pandoc.RawBlock("typst", "  bonus: true,"))
    end
    
    if title ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  title: [" .. title .. "],"))
    end
    
    if label ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  label: <" .. label .. ">,"))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    -- Insert content inline without wrapping div
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Part div
  if el.classes:includes("part") then
    local points = parse_number(get_attribute(el, "points"))
    local bonus = parse_boolean(get_attribute(el, "bonus"), false)
    local label = get_attribute(el, "label")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#part("))
    
    if points ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  points: " .. tostring(points) .. ","))
    end
    
    if bonus then
      table.insert(result, pandoc.RawBlock("typst", "  bonus: true,"))
    end
    
    if label ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  label: <" .. label .. ">,"))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    -- Insert content inline without wrapping div
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Subpart div
  if el.classes:includes("subpart") then
    local points = parse_number(get_attribute(el, "points"))
    local bonus = parse_boolean(get_attribute(el, "bonus"), false)
    local label = get_attribute(el, "label")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#subpart("))
    
    if points ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  points: " .. tostring(points) .. ","))
    end
    
    if bonus then
      table.insert(result, pandoc.RawBlock("typst", "  bonus: true,"))
    end
    
    if label ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  label: <" .. label .. ">,"))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    -- Insert content inline without wrapping div
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Subsubpart div
  if el.classes:includes("subsubpart") then
    local points = parse_number(get_attribute(el, "points"))
    local bonus = parse_boolean(get_attribute(el, "bonus"), false)
    local label = get_attribute(el, "label")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#subsubpart("))
    
    if points ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  points: " .. tostring(points) .. ","))
    end
    
    if bonus then
      table.insert(result, pandoc.RawBlock("typst", "  bonus: true,"))
    end
    
    if label ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  label: <" .. label .. ">,"))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    -- Insert content inline without wrapping div
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Solution div (renamed to solutiontext to avoid Quarto's built-in .solution handling)
  if el.classes:includes("solutiontext") then
    local style = get_attribute(el, "style")
    local height = get_attribute(el, "height")
    local title = get_attribute(el, "title")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#solution("))
    
    if style ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  style: \"" .. style .. "\","))
    end
    
    if height ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  height: " .. height .. ","))
    end
    
    if title ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  title: \"" .. title .. "\","))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    -- Insert content inline without wrapping div
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Solution or box div
  if el.classes:includes("solutionorbox") then
    local height = get_attribute(el, "height", "2in")
    local title = get_attribute(el, "title")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#solutionorbox("))
    table.insert(result, pandoc.RawBlock("typst", "  height: " .. height .. ","))
    
    if title ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  title: \"" .. title .. "\","))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Solution or lines div
  if el.classes:includes("solutionorlines") then
    local height = get_attribute(el, "height", "2in")
    local spacing = get_attribute(el, "spacing", "0.5cm")
    local title = get_attribute(el, "title")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#solutionorlines("))
    table.insert(result, pandoc.RawBlock("typst", "  height: " .. height .. ","))
    table.insert(result, pandoc.RawBlock("typst", "  spacing: " .. spacing .. ","))
    
    if title ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  title: \"" .. title .. "\","))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Solution or dotted lines div
  if el.classes:includes("solutionordottedlines") then
    local height = get_attribute(el, "height", "2in")
    local spacing = get_attribute(el, "spacing", "0.5cm")
    local title = get_attribute(el, "title")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#solutionordottedlines("))
    table.insert(result, pandoc.RawBlock("typst", "  height: " .. height .. ","))
    table.insert(result, pandoc.RawBlock("typst", "  spacing: " .. spacing .. ","))
    
    if title ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  title: \"" .. title .. "\","))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Solution or grid div
  if el.classes:includes("solutionorgrid") then
    local height = get_attribute(el, "height", "2in")
    local spacing = get_attribute(el, "spacing", "0.5cm")
    local title = get_attribute(el, "title")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#solutionorgrid("))
    table.insert(result, pandoc.RawBlock("typst", "  height: " .. height .. ","))
    table.insert(result, pandoc.RawBlock("typst", "  spacing: " .. spacing .. ","))
    
    if title ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  title: \"" .. title .. "\","))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Solution box div
  if el.classes:includes("solutionbox") then
    local height = get_attribute(el, "height", "2in")
    local title = get_attribute(el, "title")
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#solutionbox("))
    table.insert(result, pandoc.RawBlock("typst", "  height: " .. height .. ","))
    
    if title ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  title: \"" .. title .. "\","))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")["))
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Choices div (vertical list)
  if el.classes:includes("choices") then
    local correct = get_attribute(el, "correct")
    local label_style = get_attribute(el, "label-style")
    local emphasis = get_attribute(el, "emphasis")
    
    -- Extract list items
    local items = {}
    for _, block in ipairs(el.content) do
      if block.t == "BulletList" then
        for _, item in ipairs(block.content) do
          table.insert(items, item)
        end
      end
    end
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#choices("))
    
    if correct ~= nil then
      -- Check if correct is a number or letter
      local correct_num = tonumber(correct)
      if correct_num ~= nil then
        table.insert(result, pandoc.RawBlock("typst", "  correct: " .. tostring(correct_num) .. ","))
      else
        table.insert(result, pandoc.RawBlock("typst", "  correct: \"" .. correct .. "\","))
      end
    end
    
    if label_style ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  label-style: \"" .. label_style .. "\","))
    end
    
    if emphasis ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  emphasis: \"" .. emphasis .. "\","))
    end
    
    -- Add items
    for i, item in ipairs(items) do
      table.insert(result, pandoc.RawBlock("typst", "  ["))
      for _, block in ipairs(item) do
        table.insert(result, block)
      end
      table.insert(result, pandoc.RawBlock("typst", "],"))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")"))
    
    return result
  end
  
  -- Checkboxes div (vertical list)
  if el.classes:includes("checkboxes") then
    local correct = get_attribute(el, "correct")
    local checkbox_char = get_attribute(el, "checkbox-char")
    local checked_char = get_attribute(el, "checked-char")
    local emphasis = get_attribute(el, "emphasis")
    
    -- Extract list items
    local items = {}
    for _, block in ipairs(el.content) do
      if block.t == "BulletList" then
        for _, item in ipairs(block.content) do
          table.insert(items, item)
        end
      end
    end
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#checkboxes("))
    
    if correct ~= nil then
      local correct_num = tonumber(correct)
      if correct_num ~= nil then
        table.insert(result, pandoc.RawBlock("typst", "  correct: " .. tostring(correct_num) .. ","))
      else
        table.insert(result, pandoc.RawBlock("typst", "  correct: \"" .. correct .. "\","))
      end
    end
    
    if checkbox_char ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  checkbox-char: \"" .. checkbox_char .. "\","))
    end
    
    if checked_char ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  checked-char: \"" .. checked_char .. "\","))
    end
    
    if emphasis ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  emphasis: \"" .. emphasis .. "\","))
    end
    
    -- Add items
    for i, item in ipairs(items) do
      table.insert(result, pandoc.RawBlock("typst", "  ["))
      for _, block in ipairs(item) do
        table.insert(result, block)
      end
      table.insert(result, pandoc.RawBlock("typst", "],"))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")"))
    
    return result
  end
  
  -- One-paragraph choices div (inline)
  if el.classes:includes("oneparchoices") then
    local correct = get_attribute(el, "correct")
    local label_style = get_attribute(el, "label-style")
    local emphasis = get_attribute(el, "emphasis")
    
    -- Extract list items
    local items = {}
    for _, block in ipairs(el.content) do
      if block.t == "BulletList" then
        for _, item in ipairs(block.content) do
          table.insert(items, item)
        end
      end
    end
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#oneparchoices("))
    
    if correct ~= nil then
      local correct_num = tonumber(correct)
      if correct_num ~= nil then
        table.insert(result, pandoc.RawBlock("typst", "  correct: " .. tostring(correct_num) .. ","))
      else
        table.insert(result, pandoc.RawBlock("typst", "  correct: \"" .. correct .. "\","))
      end
    end
    
    if label_style ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  label-style: \"" .. label_style .. "\","))
    end
    
    if emphasis ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  emphasis: \"" .. emphasis .. "\","))
    end
    
    -- Add items
    for i, item in ipairs(items) do
      table.insert(result, pandoc.RawBlock("typst", "  ["))
      for _, block in ipairs(item) do
        table.insert(result, block)
      end
      table.insert(result, pandoc.RawBlock("typst", "],"))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")"))
    
    return result
  end
  
  -- One-paragraph checkboxes div (inline)
  if el.classes:includes("oneparcheckboxes") then
    local correct = get_attribute(el, "correct")
    local checkbox_char = get_attribute(el, "checkbox-char")
    local checked_char = get_attribute(el, "checked-char")
    local emphasis = get_attribute(el, "emphasis")
    
    -- Extract list items
    local items = {}
    for _, block in ipairs(el.content) do
      if block.t == "BulletList" then
        for _, item in ipairs(block.content) do
          table.insert(items, item)
        end
      end
    end
    
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#oneparcheckboxes("))
    
    if correct ~= nil then
      local correct_num = tonumber(correct)
      if correct_num ~= nil then
        table.insert(result, pandoc.RawBlock("typst", "  correct: " .. tostring(correct_num) .. ","))
      else
        table.insert(result, pandoc.RawBlock("typst", "  correct: \"" .. correct .. "\","))
      end
    end
    
    if checkbox_char ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  checkbox-char: \"" .. checkbox_char .. "\","))
    end
    
    if checked_char ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  checked-char: \"" .. checked_char .. "\","))
    end
    
    if emphasis ~= nil then
      table.insert(result, pandoc.RawBlock("typst", "  emphasis: \"" .. emphasis .. "\","))
    end
    
    -- Add items
    for i, item in ipairs(items) do
      table.insert(result, pandoc.RawBlock("typst", "  ["))
      for _, block in ipairs(item) do
        table.insert(result, block)
      end
      table.insert(result, pandoc.RawBlock("typst", "],"))
    end
    
    table.insert(result, pandoc.RawBlock("typst", ")"))
    
    return result
  end
  
  -- Answer space divs
  if el.classes:includes("answer-space") then
    local height = get_attribute(el, "height", "1in")
    return pandoc.RawBlock("typst", "#answer_space(" .. height .. ")")
  end
  
  if el.classes:includes("answer-box") then
    local height = get_attribute(el, "height", "2in")
    return pandoc.RawBlock("typst", "#answer_box(" .. height .. ")")
  end
  
  if el.classes:includes("answer-lines") then
    local height = get_attribute(el, "height", "2in")
    local spacing = get_attribute(el, "spacing", "0.5cm")
    return pandoc.RawBlock("typst", "#answer_lines(" .. height .. ", spacing: " .. spacing .. ")")
  end
  
  if el.classes:includes("answer-grid") then
    local height = get_attribute(el, "height", "2in")
    local spacing = get_attribute(el, "spacing", "0.5cm")
    return pandoc.RawBlock("typst", "#answer_grid(" .. height .. ", spacing: " .. spacing .. ")")
  end
  
  if el.classes:includes("answer-line") then
    local width = get_attribute(el, "width", "2in")
    local answer = get_attribute(el, "answer")
    local show_answer = parse_boolean(get_attribute(el, "show-answer"), false)
    
    local result = "#answer_line(width: " .. width
    if answer ~= nil then
      result = result .. ", answer: [" .. answer .. "]"
    end
    if show_answer then
      result = result .. ", show_answer: true"
    end
    result = result .. ")"
    
    return pandoc.RawBlock("typst", result)
  end
  
  -- Grade table div
  if el.classes:includes("grade-table") then
    local index_by = get_attribute(el, "index-by", "questions")
    local orientation = get_attribute(el, "orientation", "vertical")
    local include_bonus = parse_boolean(get_attribute(el, "include-bonus"), false)
    local max_cols = parse_number(get_attribute(el, "max-cols"))
    
    local result = "#grade_table("
    result = result .. "orientation: \"" .. orientation .. "\", "
    result = result .. "table_type: \"grade\", "
    result = result .. "include_bonus: " .. tostring(include_bonus) .. ", "
    result = result .. "index_by: \"" .. index_by .. "\""
    
    if max_cols ~= nil then
      result = result .. ", max_cols: " .. tostring(max_cols)
    end
    
    result = result .. ")"
    
    return pandoc.RawBlock("typst", result)
  end
  
  -- Point table div
  if el.classes:includes("point-table") then
    local index_by = get_attribute(el, "index-by", "questions")
    local orientation = get_attribute(el, "orientation", "vertical")
    local include_bonus = parse_boolean(get_attribute(el, "include-bonus"), false)
    local max_cols = parse_number(get_attribute(el, "max-cols"))
    
    local result = "#grade_table("
    result = result .. "orientation: \"" .. orientation .. "\", "
    result = result .. "table_type: \"point\", "
    result = result .. "include_bonus: " .. tostring(include_bonus) .. ", "
    result = result .. "index_by: \"" .. index_by .. "\""
    
    if max_cols ~= nil then
      result = result .. ", max_cols: " .. tostring(max_cols)
    end
    
    result = result .. ")"
    
    return pandoc.RawBlock("typst", result)
  end
  
  -- Uplevel div - break out of nested indentation
  if el.classes:includes("uplevel") then
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#uplevel["))
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  -- Fullwidth div - use full page width
  if el.classes:includes("fullwidth") then
    local result = {}
    table.insert(result, pandoc.RawBlock("typst", "#fullwidth["))
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("typst", "]"))
    
    return result
  end
  
  return el
end

