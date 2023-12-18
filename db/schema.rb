# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_18_213531) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alleles", force: :cascade do |t|
    t.string "name"
    t.bigint "chromosome_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "inheritable_type", null: false
    t.integer "inheritable_id", null: false
    t.index ["chromosome_id"], name: "index_alleles_on_chromosome_id"
  end

  create_table "boolean_alleles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chromosomes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "float_alleles", force: :cascade do |t|
    t.float "minimum", default: 0.0, null: false
    t.float "maximum", default: 1.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "float_values", force: :cascade do |t|
    t.float "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "generations", force: :cascade do |t|
    t.bigint "chromosome_id", null: false
    t.integer "iteration", default: -1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chromosome_id"], name: "index_generations_on_chromosome_id"
  end

  create_table "integer_alleles", force: :cascade do |t|
    t.integer "minimum", default: 0, null: false
    t.integer "maximum", default: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "integer_values", force: :cascade do |t|
    t.integer "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisms", force: :cascade do |t|
    t.bigint "generation_id", null: false
    t.integer "fitness"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["generation_id"], name: "index_organisms_on_generation_id"
  end

  create_table "values", force: :cascade do |t|
    t.bigint "organism_id", null: false
    t.bigint "allele_id", null: false
    t.string "valuable_type"
    t.integer "valuable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["allele_id"], name: "index_values_on_allele_id"
    t.index ["organism_id"], name: "index_values_on_organism_id"
  end

  add_foreign_key "alleles", "chromosomes"
  add_foreign_key "generations", "chromosomes"
  add_foreign_key "organisms", "generations"
  add_foreign_key "values", "alleles"
  add_foreign_key "values", "organisms"
end
