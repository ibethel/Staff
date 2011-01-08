<% @users.each do |user| %>
	<%= escape_javascript(render partial: "users/single", locals: {user: user}) %>
<% end %>