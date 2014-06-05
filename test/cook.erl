-module(cook).
-behaviour(sqerl_rec).

-export([
         '#insert_fields'/0,
         '#update_fields'/0,
         '#statements'/0,
         '#table_name'/0
        ]).

-compile({parse_transform, exprecs}).
-export_records([cook]).

-record(cook, {
          id,
          kitchen_id,
          name,
          auth_token,
          auth_token_bday,
          ssh_pub_key,
          first_name,
          last_name,
          email
         }).

'#insert_fields'() ->
    [kitchen_id,
     name,
     auth_token,
     ssh_pub_key,
     first_name,
     last_name,
     email].

'#update_fields'() ->
    [name,
     auth_token,
     ssh_pub_key,
     first_name,
     last_name,
     email].

'#statements'() ->
    [default,
     {insert2,
      ["INSERT INTO cookers (kitchen_id, name) "
       "SELECT k.id, $2 FROM kitchens AS k "
       "WHERE k.name = $1 RETURNING "
       "id, kitchen_id, name, auth_token, "
       "auth_token_bday, ssh_pub_key, "
       "first_name, last_name, email"]},
     {fetch_by_name_kitchen_id,
      sqerl_rec:gen_fetch(cook, [name, kitchen_id])}].

'#table_name'() ->
    "cookers".
