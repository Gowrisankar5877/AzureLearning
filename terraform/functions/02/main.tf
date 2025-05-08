# 1. ToType Functions
locals {
  num     = tonumber("10")
  str     = tostring(123)
  boolval = tobool("true")
  listval = tolist(["a", "b"])
  setval  = toset(["a", "b"])
  mapval  = tomap({ a = "1", b = "2" })
}

# 2. format()
locals {
  string1       = "str1"
  string2       = "str2"
  int1          = 3
  apply_format  = format("This is %s", local.string1)
  apply_format2 = format("%s_%s_%d", local.string1, local.string2, local.int1)
}

# 3. formatlist()
locals {
  format_list = formatlist("Hello, %s!", ["A", "B", "C"])
}

# 4. length()
locals {
  list_length   = length([10, 20, 30])
  string_length = length("abcdefghij")
}

# 5. join()
locals {
  join_string = join(",", ["a", "b", "c"])
}

# 6. try()
locals {
  map_var = {
    test = "this"
  }
  try1 = try(local.map_var.test2, "fallback")
}

# 7. can()
variable "a" {
  type = number
  default = 1234
  validation {
    condition     = can(tonumber(var.a))
    error_message = format("This is not a number: %v", var.a)
  }
}

# 8. flatten()
locals {
  unflatten_list = [[1, 2, 3], [4, 5], [6]]
  flatten_list   = flatten(local.unflatten_list)
}

# 9. keys() & values()
locals {
  key_value_map = {
    "key1" : "value1",
    "key2" : "value2"
  }
  key_list   = keys(local.key_value_map)
  value_list = values(local.key_value_map)
}

# 10. slice()
locals {
  slice_list = slice([1, 2, 3, 4], 2, 4)
}

# 11. range()
locals {
  range_one_arg    = range(3)
  range_two_args   = range(1, 3)
  range_three_args = range(1, 13, 3)
}

# 12. lookup()
locals {
  a_map            = { "key1" = "value1", "key2" = "value2" }
  lookup_in_a_map  = lookup(local.a_map, "key1", "test")
}

# 13. concat()
locals {
  concat_list = concat([1, 2, 3], [4, 5, 6])
}

# 14. merge()
locals {
  map1       = { "a" = 1, "b" = 2 }
  map2       = { "b" = 3, "c" = 4 }
  merged_map = merge(local.map1, local.map2)
}

# 15. zipmap()
locals {
  keys   = ["a", "b", "c"]
  values = [1, 2, 3]
  zipped = zipmap(local.keys, local.values)
}

# 16. file()
# Reads the contents of a file named example.txt in the same directory.
locals {
  file_content = file("main.tf")
}

# 17. filebase64()
# Reads the file and returns the Base64-encoded content.
locals {
  file_base64 = filebase64("main.tf")
}

# 18. fileexists()
locals {
  exists = fileexists("main.tf")
}


# 20. base64encode() and base64decode()
locals {
  encoded = base64encode("Hello")
  decoded = base64decode(local.encoded)
}

# 21. chomp()
locals {
  with_newline    = "hello\n"
  without_newline = chomp(local.with_newline)
}

# 22. trim(), trimspace(), and trimsuffix()
locals {
  trimmed         = trim("<<>>value<<>>", "<>")
  trimmed_space   = trimspace("  hello  ")
  trimmed_suffix  = trimsuffix("filename.txt", ".txt")
}

# 23. contains()
locals {
  sample_list    = ["a", "b", "c"]
  contains_value = contains(local.sample_list, "b")  # true
}

# 24. index()
locals {
  item_list   = ["apple", "banana", "cherry"]
  item_index  = index(local.item_list, "banana")  # 1
}

# 25. distinct()
locals {
  duplicate_list = [1, 2, 2, 3, 3, 3]
  unique_list    = distinct(local.duplicate_list)
}

# 26. sort()
locals {
  unsorted = [3, 1, 2]
  sorted   = sort(local.unsorted)
}

# 27. reverse()
locals {
  original = ["a", "b", "c"]
  reversed = reverse(local.original)
}

# OUTPUTS
output "num"                     { value = local.num }
output "str"                     { value = local.str }
output "boolval"                 { value = local.boolval }
output "listval"                 { value = local.listval }
output "setval"                  { value = local.setval }
output "mapval"                  { value = local.mapval }

output "apply_format"            { value = local.apply_format }
output "apply_format2"           { value = local.apply_format2 }

output "format_list"             { value = local.format_list }

output "list_length"             { value = local.list_length }
output "string_length"           { value = local.string_length }

output "join_string"             { value = local.join_string }

output "try1"                    { value = local.try1 }

output "flatten_list"            { value = local.flatten_list }

output "key_list"                { value = local.key_list }
output "value_list"              { value = local.value_list }

output "slice_list"              { value = local.slice_list }

output "range_one_arg"           { value = local.range_one_arg }
output "range_two_args"          { value = local.range_two_args }
output "range_three_args"        { value = local.range_three_args }

output "lookup_in_a_map"         { value = local.lookup_in_a_map }

output "concat_list"             { value = local.concat_list }

output "merged_map"              { value = local.merged_map }

output "zipped"                  { value = local.zipped }

output "file_content"            { value = local.file_content }
output "file_base64"             { value = local.file_base64 }
output "exists"                  { value = local.exists }

# output "rendered_template"       { value = local.rendered_template }

output "encoded"                 { value = local.encoded }
output "decoded"                 { value = local.decoded }

output "without_newline"         { value = local.without_newline }

output "trimmed"                 { value = local.trimmed }
output "trimmed_space"           { value = local.trimmed_space }
output "trimmed_suffix"          { value = local.trimmed_suffix }

output "contains_value"          { value = local.contains_value }

output "item_index"              { value = local.item_index }

output "unique_list"             { value = local.unique_list }

output "sorted"                  { value = local.sorted }

output "reversed"                { value = local.reversed }