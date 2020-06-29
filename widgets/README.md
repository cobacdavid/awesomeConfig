# Some awesome widgets

## for the moment
I'm trying my widgets to be easily usable in any awesome conf.
For the moment, only widgets that documented below responds to this.
Others need my `fonctionsUtiles.lua` lib. to work properly.

## calendar widget
### Installation

If you drop `calendrier.lua` file in a `widgets` directory, you
should consider thiscommand line in your `rc.lua`:

``` lua
calendrier = require("widgets.calendrier")
```

and now you can just attach this calendar to a `wibar` mouse event, e.g.

``` lua
mywibar:buttons(
    awful.util.table.join(
        awful.button({}, 1,
            function()
                calendrier.afficheCalendrier(calendrier())
            end
        )
    )
)
```

You close the calendar using mouse left-click.

![screenshot](https://github.com/cobacdavid/awesomeConfig/tree/master/widgets/calendrierScreenshot.png)


