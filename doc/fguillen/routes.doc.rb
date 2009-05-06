(in /Users/fguillen/Documents/develop-ror/euruko_app)
                              root        /                                           {:controller=>"papers", :action=>"index"}
                                          /logged_exceptions/:action/:id              {:controller=>"logged_exceptions"}
                          activate        /activate/:activation_code                  {:controller=>"users", :action=>"activate"}
                            logout        /logout                                     {:controller=>"sessions", :action=>"destroy"}
                             login        /login                                      {:controller=>"sessions", :action=>"new"}
                          register        /register                                   {:controller=>"users", :action=>"create"}
                            signup        /signup                                     {:controller=>"users", :action=>"new"}
                   forgot_password        /forgot_password                            {:controller=>"users", :action=>"forgot_password"}
                    reset_password        /reset_password/:id                         {:controller=>"users", :action=>"reset_password"}
                             users GET    /people                                     {:controller=>"users", :action=>"index"}
                   formatted_users GET    /people.:format                             {:controller=>"users", :action=>"index"}
                                   POST   /people                                     {:controller=>"users", :action=>"create"}
                                   POST   /people.:format                             {:controller=>"users", :action=>"create"}
                          new_user GET    /people/new                                 {:controller=>"users", :action=>"new"}
                formatted_new_user GET    /people/new.:format                         {:controller=>"users", :action=>"new"}
                         edit_user GET    /people/:id/edit                            {:controller=>"users", :action=>"edit"}
               formatted_edit_user GET    /people/:id/edit.:format                    {:controller=>"users", :action=>"edit"}
                              user GET    /people/:id                                 {:controller=>"users", :action=>"show"}
                    formatted_user GET    /people/:id.:format                         {:controller=>"users", :action=>"show"}
                                   PUT    /people/:id                                 {:controller=>"users", :action=>"update"}
                                   PUT    /people/:id.:format                         {:controller=>"users", :action=>"update"}
                                   DELETE /people/:id                                 {:controller=>"users", :action=>"destroy"}
                                   DELETE /people/:id.:format                         {:controller=>"users", :action=>"destroy"}
                          payments GET    /payments                                   {:controller=>"payments", :action=>"index"}
                formatted_payments GET    /payments.:format                           {:controller=>"payments", :action=>"index"}
                                   POST   /payments                                   {:controller=>"payments", :action=>"create"}
                                   POST   /payments.:format                           {:controller=>"payments", :action=>"create"}
                       new_payment GET    /payments/new                               {:controller=>"payments", :action=>"new"}
             formatted_new_payment GET    /payments/new.:format                       {:controller=>"payments", :action=>"new"}
                      edit_payment GET    /payments/:id/edit                          {:controller=>"payments", :action=>"edit"}
            formatted_edit_payment GET    /payments/:id/edit.:format                  {:controller=>"payments", :action=>"edit"}
                           payment GET    /payments/:id                               {:controller=>"payments", :action=>"show"}
                 formatted_payment GET    /payments/:id.:format                       {:controller=>"payments", :action=>"show"}
                                   PUT    /payments/:id                               {:controller=>"payments", :action=>"update"}
                                   PUT    /payments/:id.:format                       {:controller=>"payments", :action=>"update"}
                                   DELETE /payments/:id                               {:controller=>"payments", :action=>"destroy"}
                                   DELETE /payments/:id.:format                       {:controller=>"payments", :action=>"destroy"}
                            papers GET    /talks                                      {:controller=>"papers", :action=>"index"}
                  formatted_papers GET    /talks.:format                              {:controller=>"papers", :action=>"index"}
                                   POST   /talks                                      {:controller=>"papers", :action=>"create"}
                                   POST   /talks.:format                              {:controller=>"papers", :action=>"create"}
                         new_paper GET    /talks/new                                  {:controller=>"papers", :action=>"new"}
               formatted_new_paper GET    /talks/new.:format                          {:controller=>"papers", :action=>"new"}
                        edit_paper GET    /talks/:id/edit                             {:controller=>"papers", :action=>"edit"}
              formatted_edit_paper GET    /talks/:id/edit.:format                     {:controller=>"papers", :action=>"edit"}
                             paper GET    /talks/:id                                  {:controller=>"papers", :action=>"show"}
                   formatted_paper GET    /talks/:id.:format                          {:controller=>"papers", :action=>"show"}
                                   PUT    /talks/:id                                  {:controller=>"papers", :action=>"update"}
                                   PUT    /talks/:id.:format                          {:controller=>"papers", :action=>"update"}
                                   DELETE /talks/:id                                  {:controller=>"papers", :action=>"destroy"}
                                   DELETE /talks/:id.:format                          {:controller=>"papers", :action=>"destroy"}
                    paper_comments GET    /talks/:paper_id/comments                   {:controller=>"comments", :action=>"index"}
          formatted_paper_comments GET    /talks/:paper_id/comments.:format           {:controller=>"comments", :action=>"index"}
                                   POST   /talks/:paper_id/comments                   {:controller=>"comments", :action=>"create"}
                                   POST   /talks/:paper_id/comments.:format           {:controller=>"comments", :action=>"create"}
                 new_paper_comment GET    /talks/:paper_id/comments/new               {:controller=>"comments", :action=>"new"}
       formatted_new_paper_comment GET    /talks/:paper_id/comments/new.:format       {:controller=>"comments", :action=>"new"}
                edit_paper_comment GET    /talks/:paper_id/comments/:id/edit          {:controller=>"comments", :action=>"edit"}
      formatted_edit_paper_comment GET    /talks/:paper_id/comments/:id/edit.:format  {:controller=>"comments", :action=>"edit"}
                     paper_comment GET    /talks/:paper_id/comments/:id               {:controller=>"comments", :action=>"show"}
           formatted_paper_comment GET    /talks/:paper_id/comments/:id.:format       {:controller=>"comments", :action=>"show"}
                                   PUT    /talks/:paper_id/comments/:id               {:controller=>"comments", :action=>"update"}
                                   PUT    /talks/:paper_id/comments/:id.:format       {:controller=>"comments", :action=>"update"}
                                   DELETE /talks/:paper_id/comments/:id               {:controller=>"comments", :action=>"destroy"}
                                   DELETE /talks/:paper_id/comments/:id.:format       {:controller=>"comments", :action=>"destroy"}
                    paper_speakers GET    /talks/:paper_id/speakers                   {:controller=>"speakers", :action=>"index"}
          formatted_paper_speakers GET    /talks/:paper_id/speakers.:format           {:controller=>"speakers", :action=>"index"}
                                   POST   /talks/:paper_id/speakers                   {:controller=>"speakers", :action=>"create"}
                                   POST   /talks/:paper_id/speakers.:format           {:controller=>"speakers", :action=>"create"}
                 new_paper_speaker GET    /talks/:paper_id/speakers/new               {:controller=>"speakers", :action=>"new"}
       formatted_new_paper_speaker GET    /talks/:paper_id/speakers/new.:format       {:controller=>"speakers", :action=>"new"}
                edit_paper_speaker GET    /talks/:paper_id/speakers/:id/edit          {:controller=>"speakers", :action=>"edit"}
      formatted_edit_paper_speaker GET    /talks/:paper_id/speakers/:id/edit.:format  {:controller=>"speakers", :action=>"edit"}
                     paper_speaker GET    /talks/:paper_id/speakers/:id               {:controller=>"speakers", :action=>"show"}
           formatted_paper_speaker GET    /talks/:paper_id/speakers/:id.:format       {:controller=>"speakers", :action=>"show"}
                                   PUT    /talks/:paper_id/speakers/:id               {:controller=>"speakers", :action=>"update"}
                                   PUT    /talks/:paper_id/speakers/:id.:format       {:controller=>"speakers", :action=>"update"}
                                   DELETE /talks/:paper_id/speakers/:id               {:controller=>"speakers", :action=>"destroy"}
                                   DELETE /talks/:paper_id/speakers/:id.:format       {:controller=>"speakers", :action=>"destroy"}
                       paper_votes GET    /talks/:paper_id/votes                      {:controller=>"votes", :action=>"index"}
             formatted_paper_votes GET    /talks/:paper_id/votes.:format              {:controller=>"votes", :action=>"index"}
                                   POST   /talks/:paper_id/votes                      {:controller=>"votes", :action=>"create"}
                                   POST   /talks/:paper_id/votes.:format              {:controller=>"votes", :action=>"create"}
                    new_paper_vote GET    /talks/:paper_id/votes/new                  {:controller=>"votes", :action=>"new"}
          formatted_new_paper_vote GET    /talks/:paper_id/votes/new.:format          {:controller=>"votes", :action=>"new"}
                   edit_paper_vote GET    /talks/:paper_id/votes/:id/edit             {:controller=>"votes", :action=>"edit"}
         formatted_edit_paper_vote GET    /talks/:paper_id/votes/:id/edit.:format     {:controller=>"votes", :action=>"edit"}
                        paper_vote GET    /talks/:paper_id/votes/:id                  {:controller=>"votes", :action=>"show"}
              formatted_paper_vote GET    /talks/:paper_id/votes/:id.:format          {:controller=>"votes", :action=>"show"}
                                   PUT    /talks/:paper_id/votes/:id                  {:controller=>"votes", :action=>"update"}
                                   PUT    /talks/:paper_id/votes/:id.:format          {:controller=>"votes", :action=>"update"}
                                   DELETE /talks/:paper_id/votes/:id                  {:controller=>"votes", :action=>"destroy"}
                                   DELETE /talks/:paper_id/votes/:id.:format          {:controller=>"votes", :action=>"destroy"}
                   paper_attendees GET    /talks/:paper_id/attendees                  {:controller=>"attendees", :action=>"index"}
         formatted_paper_attendees GET    /talks/:paper_id/attendees.:format          {:controller=>"attendees", :action=>"index"}
                                   POST   /talks/:paper_id/attendees                  {:controller=>"attendees", :action=>"create"}
                                   POST   /talks/:paper_id/attendees.:format          {:controller=>"attendees", :action=>"create"}
                new_paper_attendee GET    /talks/:paper_id/attendees/new              {:controller=>"attendees", :action=>"new"}
      formatted_new_paper_attendee GET    /talks/:paper_id/attendees/new.:format      {:controller=>"attendees", :action=>"new"}
               edit_paper_attendee GET    /talks/:paper_id/attendees/:id/edit         {:controller=>"attendees", :action=>"edit"}
     formatted_edit_paper_attendee GET    /talks/:paper_id/attendees/:id/edit.:format {:controller=>"attendees", :action=>"edit"}
                    paper_attendee GET    /talks/:paper_id/attendees/:id              {:controller=>"attendees", :action=>"show"}
          formatted_paper_attendee GET    /talks/:paper_id/attendees/:id.:format      {:controller=>"attendees", :action=>"show"}
                                   PUT    /talks/:paper_id/attendees/:id              {:controller=>"attendees", :action=>"update"}
                                   PUT    /talks/:paper_id/attendees/:id.:format      {:controller=>"attendees", :action=>"update"}
                                   DELETE /talks/:paper_id/attendees/:id              {:controller=>"attendees", :action=>"destroy"}
                                   DELETE /talks/:paper_id/attendees/:id.:format      {:controller=>"attendees", :action=>"destroy"}
                   paper_resources GET    /talks/:paper_id/resources                  {:controller=>"resources", :action=>"index"}
         formatted_paper_resources GET    /talks/:paper_id/resources.:format          {:controller=>"resources", :action=>"index"}
                                   POST   /talks/:paper_id/resources                  {:controller=>"resources", :action=>"create"}
                                   POST   /talks/:paper_id/resources.:format          {:controller=>"resources", :action=>"create"}
                new_paper_resource GET    /talks/:paper_id/resources/new              {:controller=>"resources", :action=>"new"}
      formatted_new_paper_resource GET    /talks/:paper_id/resources/new.:format      {:controller=>"resources", :action=>"new"}
               edit_paper_resource GET    /talks/:paper_id/resources/:id/edit         {:controller=>"resources", :action=>"edit"}
     formatted_edit_paper_resource GET    /talks/:paper_id/resources/:id/edit.:format {:controller=>"resources", :action=>"edit"}
                    paper_resource GET    /talks/:paper_id/resources/:id              {:controller=>"resources", :action=>"show"}
          formatted_paper_resource GET    /talks/:paper_id/resources/:id.:format      {:controller=>"resources", :action=>"show"}
                                   PUT    /talks/:paper_id/resources/:id              {:controller=>"resources", :action=>"update"}
                                   PUT    /talks/:paper_id/resources/:id.:format      {:controller=>"resources", :action=>"update"}
                                   DELETE /talks/:paper_id/resources/:id              {:controller=>"resources", :action=>"destroy"}
                                   DELETE /talks/:paper_id/resources/:id.:format      {:controller=>"resources", :action=>"destroy"}
                       paper_photo POST   /talks/:paper_id/photo                      {:controller=>"photos", :action=>"create"}
             formatted_paper_photo POST   /talks/:paper_id/photo.:format              {:controller=>"photos", :action=>"create"}
                   new_paper_photo GET    /talks/:paper_id/photo/new                  {:controller=>"photos", :action=>"new"}
         formatted_new_paper_photo GET    /talks/:paper_id/photo/new.:format          {:controller=>"photos", :action=>"new"}
                  edit_paper_photo GET    /talks/:paper_id/photo/edit                 {:controller=>"photos", :action=>"edit"}
        formatted_edit_paper_photo GET    /talks/:paper_id/photo/edit.:format         {:controller=>"photos", :action=>"edit"}
                                   GET    /talks/:paper_id/photo                      {:controller=>"photos", :action=>"show"}
                                   GET    /talks/:paper_id/photo.:format              {:controller=>"photos", :action=>"show"}
                                   PUT    /talks/:paper_id/photo                      {:controller=>"photos", :action=>"update"}
                                   PUT    /talks/:paper_id/photo.:format              {:controller=>"photos", :action=>"update"}
                                   DELETE /talks/:paper_id/photo                      {:controller=>"photos", :action=>"destroy"}
                                   DELETE /talks/:paper_id/photo.:format              {:controller=>"photos", :action=>"destroy"}
                                   GET    /papers                                     {:controller=>"papers", :action=>"index"}
                                   GET    /papers.:format                             {:controller=>"papers", :action=>"index"}
                                   POST   /papers                                     {:controller=>"papers", :action=>"create"}
                                   POST   /papers.:format                             {:controller=>"papers", :action=>"create"}
                                   GET    /papers/new                                 {:controller=>"papers", :action=>"new"}
                                   GET    /papers/new.:format                         {:controller=>"papers", :action=>"new"}
                                   GET    /papers/:id/edit                            {:controller=>"papers", :action=>"edit"}
                                   GET    /papers/:id/edit.:format                    {:controller=>"papers", :action=>"edit"}
               update_status_paper PUT    /papers/:id/update_status                   {:controller=>"papers", :action=>"update_status"}
     formatted_update_status_paper PUT    /papers/:id/update_status.:format           {:controller=>"papers", :action=>"update_status"}
                                   GET    /papers/:id                                 {:controller=>"papers", :action=>"show"}
                                   GET    /papers/:id.:format                         {:controller=>"papers", :action=>"show"}
                                   PUT    /papers/:id                                 {:controller=>"papers", :action=>"update"}
                                   PUT    /papers/:id.:format                         {:controller=>"papers", :action=>"update"}
                                   DELETE /papers/:id                                 {:controller=>"papers", :action=>"destroy"}
                                   DELETE /papers/:id.:format                         {:controller=>"papers", :action=>"destroy"}
                             rooms GET    /rooms                                      {:controller=>"rooms", :action=>"index"}
                   formatted_rooms GET    /rooms.:format                              {:controller=>"rooms", :action=>"index"}
                                   POST   /rooms                                      {:controller=>"rooms", :action=>"create"}
                                   POST   /rooms.:format                              {:controller=>"rooms", :action=>"create"}
                          new_room GET    /rooms/new                                  {:controller=>"rooms", :action=>"new"}
                formatted_new_room GET    /rooms/new.:format                          {:controller=>"rooms", :action=>"new"}
                         edit_room GET    /rooms/:id/edit                             {:controller=>"rooms", :action=>"edit"}
               formatted_edit_room GET    /rooms/:id/edit.:format                     {:controller=>"rooms", :action=>"edit"}
                              room GET    /rooms/:id                                  {:controller=>"rooms", :action=>"show"}
                    formatted_room GET    /rooms/:id.:format                          {:controller=>"rooms", :action=>"show"}
                                   PUT    /rooms/:id                                  {:controller=>"rooms", :action=>"update"}
                                   PUT    /rooms/:id.:format                          {:controller=>"rooms", :action=>"update"}
                                   DELETE /rooms/:id                                  {:controller=>"rooms", :action=>"destroy"}
                                   DELETE /rooms/:id.:format                          {:controller=>"rooms", :action=>"destroy"}
                            events GET    /events                                     {:controller=>"events", :action=>"index"}
                  formatted_events GET    /events.:format                             {:controller=>"events", :action=>"index"}
                                   POST   /events                                     {:controller=>"events", :action=>"create"}
                                   POST   /events.:format                             {:controller=>"events", :action=>"create"}
                         new_event GET    /events/new                                 {:controller=>"events", :action=>"new"}
               formatted_new_event GET    /events/new.:format                         {:controller=>"events", :action=>"new"}
                        edit_event GET    /events/:id/edit                            {:controller=>"events", :action=>"edit"}
              formatted_edit_event GET    /events/:id/edit.:format                    {:controller=>"events", :action=>"edit"}
                             event GET    /events/:id                                 {:controller=>"events", :action=>"show"}
                   formatted_event GET    /events/:id.:format                         {:controller=>"events", :action=>"show"}
                                   PUT    /events/:id                                 {:controller=>"events", :action=>"update"}
                                   PUT    /events/:id.:format                         {:controller=>"events", :action=>"update"}
                                   DELETE /events/:id                                 {:controller=>"events", :action=>"destroy"}
                                   DELETE /events/:id.:format                         {:controller=>"events", :action=>"destroy"}
                          calendar POST   /calendar                                   {:controller=>"calendars", :action=>"create"}
                formatted_calendar POST   /calendar.:format                           {:controller=>"calendars", :action=>"create"}
                      new_calendar GET    /calendar/new                               {:controller=>"calendars", :action=>"new"}
            formatted_new_calendar GET    /calendar/new.:format                       {:controller=>"calendars", :action=>"new"}
                     edit_calendar GET    /calendar/edit                              {:controller=>"calendars", :action=>"edit"}
           formatted_edit_calendar GET    /calendar/edit.:format                      {:controller=>"calendars", :action=>"edit"}
                                   GET    /calendar                                   {:controller=>"calendars", :action=>"show"}
                                   GET    /calendar.:format                           {:controller=>"calendars", :action=>"show"}
                                   PUT    /calendar                                   {:controller=>"calendars", :action=>"update"}
                                   PUT    /calendar.:format                           {:controller=>"calendars", :action=>"update"}
                                   DELETE /calendar                                   {:controller=>"calendars", :action=>"destroy"}
                                   DELETE /calendar.:format                           {:controller=>"calendars", :action=>"destroy"}
                             carts GET    /pay                                        {:controller=>"carts", :action=>"index"}
                   formatted_carts GET    /pay.:format                                {:controller=>"carts", :action=>"index"}
                                   POST   /pay                                        {:controller=>"carts", :action=>"create"}
                                   POST   /pay.:format                                {:controller=>"carts", :action=>"create"}
                          new_cart GET    /pay/new                                    {:controller=>"carts", :action=>"new"}
                formatted_new_cart GET    /pay/new.:format                            {:controller=>"carts", :action=>"new"}
                         edit_cart GET    /pay/:id/edit                               {:controller=>"carts", :action=>"edit"}
               formatted_edit_cart GET    /pay/:id/edit.:format                       {:controller=>"carts", :action=>"edit"}
                     complete_cart GET    /pay/:id/complete                           {:controller=>"carts", :action=>"complete"}
           formatted_complete_cart GET    /pay/:id/complete.:format                   {:controller=>"carts", :action=>"complete"}
                   notificate_cart POST   /pay/:id/notificate                         {:controller=>"carts", :action=>"notificate"}
         formatted_notificate_cart POST   /pay/:id/notificate.:format                 {:controller=>"carts", :action=>"notificate"}
                      confirm_cart POST   /pay/:id/confirm                            {:controller=>"carts", :action=>"confirm"}
            formatted_confirm_cart POST   /pay/:id/confirm.:format                    {:controller=>"carts", :action=>"confirm"}
                              cart GET    /pay/:id                                    {:controller=>"carts", :action=>"show"}
                    formatted_cart GET    /pay/:id.:format                            {:controller=>"carts", :action=>"show"}
                                   PUT    /pay/:id                                    {:controller=>"carts", :action=>"update"}
                                   PUT    /pay/:id.:format                            {:controller=>"carts", :action=>"update"}
                                   DELETE /pay/:id                                    {:controller=>"carts", :action=>"destroy"}
                                   DELETE /pay/:id.:format                            {:controller=>"carts", :action=>"destroy"}
                           session POST   /session                                    {:controller=>"sessions", :action=>"create"}
                 formatted_session POST   /session.:format                            {:controller=>"sessions", :action=>"create"}
                       new_session GET    /session/new                                {:controller=>"sessions", :action=>"new"}
             formatted_new_session GET    /session/new.:format                        {:controller=>"sessions", :action=>"new"}
                      edit_session GET    /session/edit                               {:controller=>"sessions", :action=>"edit"}
            formatted_edit_session GET    /session/edit.:format                       {:controller=>"sessions", :action=>"edit"}
                                   GET    /session                                    {:controller=>"sessions", :action=>"show"}
                                   GET    /session.:format                            {:controller=>"sessions", :action=>"show"}
                                   PUT    /session                                    {:controller=>"sessions", :action=>"update"}
                                   PUT    /session.:format                            {:controller=>"sessions", :action=>"update"}
                                   DELETE /session                                    {:controller=>"sessions", :action=>"destroy"}
                                   DELETE /session.:format                            {:controller=>"sessions", :action=>"destroy"}
                       static_page GET    /static_pages/:id                           {:controller=>"static_pages", :action=>"show"}
             formatted_static_page GET    /static_pages/:id.:format                   {:controller=>"static_pages", :action=>"show"}
                          invoices POST   /invoices                                   {:controller=>"invoices", :action=>"create"}
                formatted_invoices POST   /invoices.:format                           {:controller=>"invoices", :action=>"create"}
                  location_searchs POST   /location_searchs                           {:controller=>"location_searchs", :action=>"create"}
        formatted_location_searchs POST   /location_searchs.:format                   {:controller=>"location_searchs", :action=>"create"}
          avaliable_places_counter GET    /avaliable_places_counter                   {:controller=>"avaliable_places_counters", :action=>"show"}
formatted_avaliable_places_counter GET    /avaliable_places_counter.:format           {:controller=>"avaliable_places_counters", :action=>"show"}
                                          /:controller/:action/:id                    
                                          /:controller/:action/:id.:format            
