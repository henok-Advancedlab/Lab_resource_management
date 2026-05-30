# Lab Equipment Management API

A centralized RESTful JSON API built with Ruby on Rails to track laboratory resources, equipment statuses, and historical maintenance logs.

## Setup Instructions
```bash
git clone <repo-url>
cd Lab_resource_management
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
