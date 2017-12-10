# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project
- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Recipes) -- User has_many Hunts, User has_many Teams, Team has_many Participants(Users), Hunt has_many Items, Location has_many Hunts, Location has_many Users
- [x] Include at least one belongs_to relationship (x belongs_to y e.g. Post belongs_to User) -- Hunt belongs_to Location, User belongs_to Location, Item belongs_to Hunt, Hunt belongs_to Owner(User)
- [x] Include at least one has_many through relationship (x has_many y through z e.g. Recipe has_many Items through Ingredients) -- User has_many Items through Hunts, Hunt has_many Participants through Teams
- [x] The "through" part of the has_many through includes at least one user submittable attribute (attribute_name e.g. ingredients.quantity) -- Hunt has_many participants through Teams (can update Team#name)
- [x] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item) -- Hunt (start_time, finish_time, name, location), Item (name), Location (city, state), User (name, email)
- [x] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes) -- Hunt.pending_in(location), /hunts; Hunt.top_five, root (must be logged out to view);
- [x] Include a nested form writing to an associated model using a custom attribute writer (form URL, model name e.g. /recipe/new, Item) -- Hunt/Items /hunts/new; User/Location /users/:id/edit
- [x] Include signup (how e.g. Devise) -- Devise
- [x] Include login (how e.g. Devise) -- Devise
- [x] Include logout (how e.g. Devise) -- Devise
- [x] Include third party signup/login (how e.g. Devise/OmniAuth) -- Devise/OmniAuth for Facebook
- [x] Include nested resource show or index (URL e.g. users/2/recipes) -- /hunts/:id/teams/:id
- [x] Include nested resource "new" form (URL e.g. recipes/1/ingredients) -- /hunts/:id/teams/new
- [x] Include form display of validation errors (form URL e.g. /recipes/new) -- /hunts/new

Confirm:
- [ ] The application is pretty DRY
- [ ] Limited logic in controllers
- [ ] Views use helper methods if appropriate
- [ ] Views use partials if appropriate
