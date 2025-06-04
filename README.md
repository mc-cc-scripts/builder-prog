# builder-prog
Will be our all in one building program

# Current Functions



### help


```lua
-- Returns all available commands
builder help
```

### floor

```lua
-- Builds a floor with the specified size.
-- Uses the Item in Slot 1 as Buildingblock!
builder floor -w <width> -l <length> -mH <"left"|"right">
```

### clearArea

```lua
-- clears an Area of the specifed size
builder clearArea -w <width> -l <length> -h <height> -mH <"left"|"right"> -mV <"up"|"down">
```
