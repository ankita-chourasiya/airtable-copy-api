# README

Things you may want to cover:

1. Setup an Airtable with the following dummy data:

  - Create [airtable.com](http://airtable.com/) account
  - Go to https://airtable.com/account and generate & copy the API key
  - Go to [https://airtable.com](https://airtable.com/) and click on `Add a base` from scratch and call it `Copy`
  - Set 2 columns called `Key` and `Copy`
  - Add these rows
      - `greeting`, `Hi {name}, welcome to {app}!`
      - `greetingVIP`, `{greeting} You're on the VIP plan.`
      - `intro.created_at`, `Intro created on {created_at, datetime}`
      - `intro.updated_at`, `Intro updated on {updated_at, datetime}`

2. Configure your credentials(`AIRTABLE_API_KEY`, `AIRTABLE_BASE_ID`, `AIRTABLE_TABLE_NAME`) in .env file

3. Load data from the local JSON file:
  `rake load:copy`

  If we don't have the data in local JSON file or not have the JSON file(`copy.json`)

  then,

  -  Run the test task for store your airtable data into the json file(copy.json) in the root directory:
    `rake import:copy`

4. Run the rails server
  `rails s`

Requirement link:

https://brdgapp.notion.site/Ruby-on-rails-coding-challenges-c08621b4f9f14ecfa841bc0b4ad1a245

Note: This repo is for Challenge #1: Copy API in the above link
      Challenge #1: Copy API coding challenge (https://brdgapp.notion.site/Copy-API-coding-challenge-0eef1dc4ef754bcca69076de5d532a5b)
