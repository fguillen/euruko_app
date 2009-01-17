# Simplified Permalink

I know there are some plugins out there that do the same, but this one 
fits my needs.

## Example

Add to your posts the permalink attribute.

    add_column :posts, :permalink, :null => false
    add_index :posts, :permalink

And use it on your controllers.

    class Post < ActiveRecord::Base
      permalink :title
    end

    class Post < ActiveRecord::Base
      permalink :title, :slug
    end

So now you can find your posts with:

    class Posts < ApplicationController

      def show
        @post = Post.find_by_permalink_and_status!(params[:id])
      end

    end

## About the Author

Francesc Esplugas <hello@francescesplugas.com>

You can recommend me at http://workingwithrails.com/person/5061-francesc-esplugas

Copyright (c) 2008-2009 Francesc Esplugas Marti, released under the MIT license