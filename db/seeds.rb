Companytype.create!([
  {companytype_name: "Altius", description: nil}
])
User.create!([
  {first_name: "Manisankar", last_name: "G", email_id: "manisankar.gnanasekaran@adcltech.com", password: nil, phone_number: "79292934343", remarks: nil, usertype_id: 2, approval_id: nil, tenant_id: nil, role_id: nil, isactive: nil, deleted_at: nil, password_digest: "$2a$10$gqSGfoX0.5BrdtQ7nC68wup9kSf4k9k693plO8T7rGXibI7XIZ.fe", default: "mani"}
])
Usertype.create!([
  {usertype_name: "Altius-client", description: nil},
  {usertype_name: "Altius-user", description: nil}
])
