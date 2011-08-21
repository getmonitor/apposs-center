# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
# cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
# Mayor.create(:name => 'Daley', :city => cities.first)

#cmd_group = CmdGroup.create :name => 'jboss'

#cmd_group2 = CmdGroup.create :name => 'nodejs'

#cmd_group.directive_templates << DirectiveTemplate.create(:name => 'echo start')
#cmd_group.directive_templates << DirectiveTemplate.create(:name => 'echo stop')
#cmd_group.directive_templates << DirectiveTemplate.create(:name => 'echo redeploy')

#cmd_group2.directive_templates << DirectiveTemplate.create( :name => 'echo start_nodejs')
#cmd_group2.directive_templates << DirectiveTemplate.create( :name => 'echo stop_nodejs')

#app = App.create(:name => 'sample-app',:online => true)
#app.machines << Machine.create(:name => 'tanx1.cnz',:host => 'localhost',:port => 22)
#app.machines << Machine.create(:name => 'tanx2.cnz',:host => 'test',:port => 22)
#Machine.create(:name => 'tanx3.cnz',:host => 'test',:port => 22)

#app.operation_templates << OperationTemplate.create(:name => "upgrade package", :expression => '1,2|true,4')
#


admin_role = Role.create(:name => Role::Admin)
pe_role = Role.create(:name => Role::PE)
appops_role = Role.create(:name => Role::APPOPS)
u = User.create(:email => 'lifu@taobao.com', :password => 'hahaha')
Stakeholder.create :user => u, :role => admin_role

#%w{cnz cm3 cm4}.each{|name| Room.create(:name => name)}
#Room.first.machines << Machine.all

#App.first.operation_templates.first.create_cmd_set User.first
