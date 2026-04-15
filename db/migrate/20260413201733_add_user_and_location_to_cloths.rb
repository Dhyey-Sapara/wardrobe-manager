class AddUserAndLocationToCloths < ActiveRecord::Migration[8.1]
  def up
    add_reference :cloths, :user, foreign_key: true
    add_reference :cloths, :location, foreign_key: true

    # Create admin user via raw SQL to avoid model dependency issues
    password_digest = BCrypt::Password.create("changeme").to_s
    execute "INSERT INTO users (email, password_digest, admin, created_at, updated_at) VALUES (#{connection.quote('admin@wardrobe.local')}, #{connection.quote(password_digest)}, true, NOW(), NOW())"
    admin_id = execute("SELECT id FROM users WHERE email = 'admin@wardrobe.local'").first["id"].to_i

    # Only migrate if cloths exist
    cloth_count = execute("SELECT COUNT(*) AS count FROM cloths").first["count"].to_i
    if cloth_count > 0
      # Determine which old location enum values are present (0=Surat, 1=Indore)
      existing_loc_values = execute("SELECT DISTINCT location FROM cloths WHERE location IS NOT NULL").map { |r| r["location"].to_i }

      location_id_map = {}
      existing_loc_values.each do |loc_int|
        name = loc_int == 0 ? "Surat" : "Indore"
        execute "INSERT INTO locations (name, user_id, created_at, updated_at) VALUES (#{connection.quote(name)}, #{admin_id}, NOW(), NOW())"
        location_id_map[loc_int] = execute("SELECT id FROM locations WHERE name = #{connection.quote(name)} AND user_id = #{admin_id}").first["id"].to_i
      end

      # Assign each cloth to admin and map its location
      location_id_map.each do |loc_int, loc_id|
        execute "UPDATE cloths SET user_id = #{admin_id}, location_id = #{loc_id} WHERE location = #{loc_int}"
      end

      # Handle any cloths with null location
      execute "UPDATE cloths SET user_id = #{admin_id} WHERE user_id IS NULL"
    end

    change_column_null :cloths, :user_id, false
    remove_column :cloths, :location, :integer
  end

  def down
    add_column :cloths, :location, :integer, default: 0
    change_column_null :cloths, :user_id, true
    remove_reference :cloths, :location, foreign_key: true
    remove_reference :cloths, :user, foreign_key: true
  end
end
