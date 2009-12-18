page.replace_html :friends, :partial => 'no_friendships', :object => @not_friends_yet
#page.visual_effect :highlight, 'friends', :duration=>2
page[:new_friendship].reset