terraform {
  required_providers {
    diceroll = {
      source  = "briancain/diceroll"
      version = ">=0.1.10"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.6.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

resource "diceroll_roll" "dnd" {
  quantity = 4
  sides    = 20
  seed     = var.die_seed != "" ? var.die_seed : random_string.random.result
}

resource "random_string" "random" {
  length           = 16
  special          = false
}

provider "github" {
  owner = var.destination_org
  token = var.gh_token
}

resource "github_repository" "gh_repo" {
  name       = var.waypoint_application
  visibility = "public"

  template {
    owner                = var.template_org
    repository           = var.template_repo
    include_all_branches = false
  }

  # Enable GitHub pages
  pages {
    build_type = "workflow"
  }
}

resource "github_repository_file" "readme" {
  repository = github_repository.gh_repo.name
  branch     = "main"
  file       = "README.md"
  content = templatefile("${path.module}/templates/README.md", {
    application_name  = var.waypoint_application,
    destination_org   = var.destination_org
  })
  commit_message      = "Add readme file."
  commit_author       = var.commit_author
  commit_email        = var.commit_email
  overwrite_on_create = true
}

resource "github_repository_file" "index_html" {
  repository = github_repository.gh_repo.name
  branch     = "main"
  file       = "index.html"
  content = templatefile("${path.module}/templates/index.html", {
    application_name  = var.waypoint_application,
    diceroll_total    = diceroll_roll.dnd.calculated_total
  })
  commit_message      = "Add index file."
  commit_author       = var.commit_author
  commit_email        = var.commit_email
  overwrite_on_create = true

  depends_on = [github_repository_file.readme, diceroll_roll.dnd]
}
