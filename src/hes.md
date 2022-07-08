# H Entertainment System
The HES is a virtual video game console, designed to be able to be emulated on almost any platform.

Memory layout:
| 8 bytes                         | 8 bytes                         |
|---------------------------------|---------------------------------|
| Registers                       | Video (swappable)               |
| General purpose / Save data     | General purpose / Sprite data   |
| General purpose                                                   |
| General purpose                                                   |
| General purpose                                                   |
| Instructions (swappable)                                          |

All registers are 8-bit, except Next instruction address, which is split into 2 8-bit registers
Registers:
| Byte offset | Name                          |
|-------------|-------------------------------|
| 0           | Arithmetic operation output   |
| 1           | Arithmetic operation flags    |
| 2           | Video flags                   |
| 3           | Input                         |
| 4-5         | Next instruction address      |
| 6           | Save data + Sprite data flags |
| 7           | Character                     |

Video has 1-bit color and is 32x32 pixels large. The pixels in the Video memory zone are ordered from left to right, top to bottom.
The Video memory zone can be swapped to represent 1 of 16 sectors of the actual screen. Each number in the table below represents the number of the sector:
|   |   |   |   |
|---|---|---|---|
| 0 | 1 | 2 | 3 |
| 4 | 5 | 6 | 7 |
| 8 | 9 | A | B |
| C | D | E | F |

Video flags:
| Bit offset | Name   | Details                                                                |
|------------|--------|------------------------------------------------------------------------|
| 0-2        | Sector | The sector that the Video memory zone represents                       |
| 3-7        | Color  | The color to use when writing pixels to the screen. See PICO-8 palette |

The Input register consists of 8 bits, representing the state of each button on the controller. The controller is similar to an NES controller (Left, Right, Up, Down, A, B, Start, Select)
| Bit offset | Name   |
|------------|--------|
| 0          | Right  |
| 1          | Left   |
| 2          | Up     |
| 3          | Down   |
| 4          | A      |
| 5          | B      |
| 6          | Start  |
| 7          | Select |


