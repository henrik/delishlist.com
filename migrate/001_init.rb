class Init < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.text :item_url, :null => false
      t.text :image_url, :null => true
      t.string :username, :null => false
      t.string :ip
      t.timestamps
    end
    add_index :images, :item_url
  end

  def self.down
    drop_table :images
  end
end
