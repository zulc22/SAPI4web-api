cl sapi4.cpp ole32.lib user32.lib /MT /LD -Ox -I"C:\Program Files\Microsoft Speech SDK\Include"
cl sapi4out.cpp ole32.lib user32.lib sapi4.lib /MT -Ox -I"C:\Program Files\Microsoft Speech SDK\Include"
cl sapi4limits.cpp ole32.lib user32.lib sapi4.lib /MT -Ox -I"C:\Program Files\Microsoft Speech SDK\Include"