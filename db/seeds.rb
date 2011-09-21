admin_role = Role.create(:name => Role::Admin)
pe_role = Role.create(:name => Role::PE)
appops_role = Role.create(:name => Role::APPOPS)
u = User.create(:email => 'lifu@taobao.com', :password => 'hahaha')
Stakeholder.create :user => u, :role => admin_role
