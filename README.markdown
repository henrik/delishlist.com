# Delishlist

Medium-sized Sinatra [site](http://delishlist.com) (rewritten from Merb) deployed with Capistrano.

Wraps links tagged `wishlist` on [Delicious](http://delicious.com) or [Pinboard](http://pinboard.in) in better presentation.

Not affiliated with Yahoo! Inc., owner of the "Delicious" trademark, nor with Pinboard.

## Dev

    bundle
    createdb delishlist_dev
    rake db:migrate
    rackup
    open http://localhost:9292

## Credits and license

"Anchor", "Edit" and "Picture" icons are by [Mark James](http://www.famfamfam.com) under Creative Commons Attribution 2.5.

The adapted data from Delicious is licensed under Creative Commons Attribution Share-Alike 3.0.

Other code and graphics by [Henrik Nyh](http://henrik.nyh.se/) under the MIT license:

>  Copyright (c) 2010 Henrik Nyh
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
