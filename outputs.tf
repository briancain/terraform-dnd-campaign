output "repo_url" {
  value       = github_repository.gh_repo.html_url
  description = "The URL of the created repository."
}

output "app_url" {
  value       = "https://${var.destination_org}.github.io/${var.waypoint_application}"
  description = "The URL of the app on GitHub Pages."
}

output "dnd_roll" {
  value = diceroll_roll.dnd
}

output "dnd_roll_result" {
  value = diceroll_roll.dnd.result
}

output "dnd_calculated_total" {
  value = diceroll_roll.dnd.calculated_total
}
