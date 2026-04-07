output "id" {
  description = "The full ARM resource ID of the management lock."
  value       = local.lock_path
}

output "lock_name" {
  description = "The name of the management lock (echoes input)."
  value       = var.lock_name
}

output "lock_level" {
  description = "The lock level (echoes input)."
  value       = var.lock_level
}
