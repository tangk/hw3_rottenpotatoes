# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  if page.respond_to? :should
    page.should have_content(e1)
    page.should have_content(e2)
  else
    assert page.has_content?(e1)
    assert page.has_content?(e2)
    # assert_block do
    #   (page.body.index(e1) < page.body.index(e2)) or (page.body.index(e1.reverse) > page.body.index(e2.reverse))
    # end
  end
  assert_operator page.body.index(e1), :<, page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  @rating_list = rating_list.split(%r{,\s*})
  if uncheck
    @rating_list.each {|rate| uncheck("ratings_#{rate}")}
  else
    @rating_list.each {|rate| check("ratings_#{rate}")}
  end
end

When /I uncheck all other checkboxes/ do
  @rating_list_rem = Movie.all_ratings
  @rating_list_rem.delete_if {|rate| @rating_list.include?(rate)}
  @rating_list_rem.each {|rate| uncheck("ratings_#{rate}")}
end

When /I should click (.*)/ do |button|
  click_button(button)
end

Then /I should see movies with ratings: (.*)/ do |rating_list|
  @rating_list = rating_list.split(%r{,\s*})
  movies = Movie.find_all_by_rating(@rating_list)
  movies.each do |movie|
    if page.respond_to? :should
      page.should have_content(movie.title)
    else
      assert page.has_content?(movie.title)
    end
  end
end

Then /I should not see other movies/ do
  @rating_list_rem = Movie.all_ratings
  @rating_list_rem.delete_if {|rate| @rating_list.include?(rate)}
  movies = Movie.find_all_by_rating(@rating_list_rem)
  movies.each do |movie|
    if page.respond_to? :should
      page.should have_no_content(movie.title)
    else
      assert page.has_no_content?(movie.title)
    end
  end
end

When /I (un)?check all the ratings/ do |uncheck|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  @rating_list = Movie.all_ratings
  if uncheck
    @rating_list.each {|rate| uncheck("ratings_#{rate}")}
  else
    @rating_list.each {|rate| check("ratings_#{rate}")}
  end
end  

Then /I should see all of the movies/ do
  movies = Movie.all
  movies.each do |movie|
    if page.respond_to? :should
      page.should have_content(movie.title)
    else
      assert page.has_content?(movie.title)
    end
  end
end

When /I follow "(.*)"/ do |text|
  click_link(text)
end