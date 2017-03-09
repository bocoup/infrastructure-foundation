output "subnet_ids" {
  value = "${module.subnet.ids}"
}

output "subnet_cidrs" {
  value = "${module.subnet.cidr_blocks}"
}

output "subnet_route_table_id" {
  value = "${module.subnet.route_table_id}"
}

output "vpc_id" {
  value = "${module.vpc.id}"
}

output "vpc_cidr" {
  value = "${module.vpc.cidr}"
}
