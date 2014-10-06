Twitter Client For Codepath Week 3

Part 1
- Hours Required For Completion: 14
2. Stories
  * :white_check_mark: User can sign in using OAuth login flow
  * :white_check_mark: User can view last 20 tweets from their home timeline
  * :white_check_mark: The current signed in user will be persisted across restarts
  * :white_check_mark: In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
  * :white_check_mark: User can pull to refresh
  * :white_check_mark: User can compose a new tweet by tapping on a compose button.
  * :white_check_mark: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
  * :white_check_mark: Optional: When composing, you should have a countdown in the upper right for the tweet limit.
  * :white_large_square: Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
  * :white_check_mark: Optional: Retweeting and favoriting should increment the retweet and favorite count.
  * :white_check_mark: Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
  * :white_check_mark: Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
  * :white_check_mark: Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

[![General Functionality](https://github.com/franklinho/TwitterClient/blob/master/TwitterClient.gif)]


Part 2

- Hours Required For Completion: 8

2. Stories
  * Hamburger menu
    * :white_check_mark: Dragging anywhere in the view should reveal the menu.
    * :white_check_mark: The menu should include links to your profile, the home timeline, and the mentions view.
    * :white_check_mark: The menu can look similar to the LinkedIn menu below or feel free to take liberty with the UI.
  * Profile page
    * :white_check_mark: Contains the user header view
    * :white_check_mark: Contains a section with the users basic stats: # tweets, # following, # followers
    * :white_large_square: Optional: Implement the paging view for the user description.
    * :white_large_square: Optional: As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
    * :white_large_square: Optional: Pulling down the profile page should blur and resize the header image.
  * Home Timeline
    * :white_check_mark: Tapping on a user image should bring up that user's profile page
  * Optional: Account switching
    * :white_large_square: Long press on tab bar to bring up Account view with animation
    * :white_large_square: Tap account to switch to
    * :white_large_square: Include a plus button to Add an Account
    * :white_large_square: Swipe to delete an account