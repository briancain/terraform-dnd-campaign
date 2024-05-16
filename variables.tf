variable "template_org" {
  description = "The name of the organization in GitHub that will contain the example app repo."
}

variable "template_repo" {
  description = "The name of the repository in GitHub that contains the example app code."
}

variable "destination_org" {
  description = "The name of the organization in GitHub that will contain the templated repo."
}

variable "gh_token" {
  description = "GitHub token with permissions to create and delete repos."
}

variable "commit_author" {
  description = "The name of the author to use for commits."
  default     = "Waypoint Bot"
}

variable "commit_email" {
  description = "The email address of the author to use for commits."
  default     = "fixme@example.com"
}

variable "waypoint_application" {
  type        = string
  description = "Name of the Waypoint application."

  validation {
    condition     = !contains(["-", "_"], var.waypoint_application)
    error_message = "waypoint_application must not contain dashes or underscores."
  }
}
