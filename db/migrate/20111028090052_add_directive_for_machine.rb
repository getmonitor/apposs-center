class AddDirectiveForMachine < ActiveRecord::Migration
  def self.up

    default_group = DirectiveGroup.where(:name => 'default').first

    DirectiveTemplate.create(
      :name => 'machine|pause',
      :alias => 'machine|pause',
      :directive_group => default_group
    )
    DirectiveTemplate.create(
      :name => 'machine|interrupt',
      :alias => 'machine|interrupt',
      :directive_group => default_group
    )
    DirectiveTemplate.create(
      :name => 'machine|clean_all',
      :alias => 'machine|clean_all',
      :directive_group => default_group
    )
  end

  def self.down
    default_group = DirectiveGroup.where(:name => 'default').first

    DirectiveTemplate.where(
      :name => 'machine|pause',
      :directive_group => default_group
    ).delete_all
    DirectiveTemplate.where(
      :name => 'machine|interrupt',
      :directive_group => default_group
    ).delete_all
    DirectiveTemplate.where(
      :name => 'machine|clean_all',
      :directive_group => default_group
    ).delete_all
  end
end
