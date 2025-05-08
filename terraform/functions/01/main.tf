locals {
 string1       = "Gowri"
 string2       = "Sankar"
 int1          = 3
 apply_format  = format("This is %s", local.string1)
 apply_format2 = format("%s_%s_%d", local.string1, local.string2, local.int1)
}

output "apply_format" {
 value = local.apply_format
}
output "apply_format2" {
 value = local.apply_format2
}