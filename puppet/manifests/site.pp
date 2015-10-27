hiera_include('classes')
hiera_resources('my_resources')

Yumrepo <| |> -> Package <| provider != 'rpm' |>




