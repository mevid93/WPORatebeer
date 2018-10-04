class ConnectBeerToStyle < ActiveRecord::Migration[5.2]
  def change
    Beer.find_each do |b|
      s = Style.find_by(name:b.old_style)
      b.style_id = s.id
      b.save
    end
  end
end
