# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_22_213316) do

  create_table "ez_permissions_model_roles", force: :cascade do |t|
    t.integer "model_id", null: false
    t.string "model_type", null: false
    t.integer "scoped_id"
    t.string "scoped_type"
    t.integer "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_id"], name: "index_ez_permissions_model_roles_on_model_id"
    t.index ["model_type"], name: "index_ez_permissions_model_roles_on_model_type"
    t.index ["role_id"], name: "index_ez_permissions_model_roles_on_role_id"
    t.index ["scoped_id"], name: "index_ez_permissions_model_roles_on_scoped_id"
    t.index ["scoped_type"], name: "index_ez_permissions_model_roles_on_scoped_type"
  end

  create_table "ez_permissions_permissions", force: :cascade do |t|
    t.string "resource", null: false
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action"], name: "index_ez_permissions_permissions_on_action"
    t.index ["resource"], name: "index_ez_permissions_permissions_on_resource"
  end

  create_table "ez_permissions_permissions_roles", force: :cascade do |t|
    t.integer "permission_id", null: false
    t.integer "role_id"
    t.index ["permission_id"], name: "index_ez_permissions_permissions_roles_on_permission_id"
    t.index ["role_id"], name: "index_ez_permissions_permissions_roles_on_role_id"
  end

  create_table "ez_permissions_roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
