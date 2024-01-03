#! /usr/bin/env python3

from tkinter import *
# ---------------------------- CONSTANTS ------------------------------- #
SHORT_BREAK_COLOR = "#B79CED"
LONG_BREAK_COLOR = "#f76c5e"
WORK_COLOR = "#7161EF"
CHECK_COLOR = "#7161EF"
BACKGROUND = "#DEC0F1"
FONT_NAME = "Courier"
WORK_MIN = 25
SHORT_BREAK_MIN = 5
LONG_BREAK_MIN = 20
reps = 0
timer = None
window_position = None


# ---------------------------- TIMER RESET ------------------------------- # 
def reset_pomodoro():
    window.call('wm', 'attributes', '.', '-topmost', False)
    window.after_cancel(timer)
    canvas.itemconfig(timer_text, text="00:00")
    title_label.config(text="Timer", fg=WORK_COLOR)
    check_marks.config(text="")

    global reps
    reps = 0
    start_button.config(state="normal")

# ---------------------------- TIMER MECHANISM ------------------------------- # 
def start_timer():
    start_button.config(state="disabled")
    global reps
    reps += 1

    # for debugging:
    # work_seconds = 10
    # short_break_seconds = 5
    # long_break_seconds = 15
    work_seconds = WORK_MIN * 60
    short_break_seconds = SHORT_BREAK_MIN * 60
    long_break_seconds = LONG_BREAK_MIN * 60
    
    # if 1st/3rd/5th/7th rep -- working:
    if (reps % 2 != 0):
        title_label.config(text="Work", fg=WORK_COLOR)
        canvas.itemconfig(image_container, image=working_img)

        count_down(work_seconds)
    elif (reps == 8):
    # if it's 8th rep: -- taking long break
        title_label.config(text="Long Break", fg=LONG_BREAK_COLOR)
        canvas.itemconfig(image_container, image=long_break_img)
        count_down(long_break_seconds)
    else:
    # if it's 2nd/4th/6th rep: -- taking short break
        title_label.config(text="Short Break", fg=SHORT_BREAK_COLOR)
        canvas.itemconfig(image_container, image=short_break_img)
        count_down(short_break_seconds)

# ---------------------------- UI SETUP ------------------------------- #
window = Tk()
window.title("Pomodoro")
window.config(padx=100, pady=50, bg=BACKGROUND)

# ---------------------------- COUNTDOWN MECHANISM ------------------------------- #
def count_down(seconds):
    #00:00 format
    minutes_display = seconds // 60
    seconds_display = seconds % 60
    # change canvas text
    if (seconds_display < 10):
        canvas.itemconfig(timer_text, text=f"{minutes_display}:0{seconds_display}")
    else:
        canvas.itemconfig(timer_text, text=f"{minutes_display}:{seconds_display}")

    if seconds > 0:
        global timer
        timer = window.after(1000, count_down, seconds - 1) #in ms (1000ms = 1s)
    else:
        # after 00:00, start_timer() again
        window.call('wm', 'attributes', '.', '-topmost', True)

        global window_position
        window_position = window.after(5000, window.call, 'wm', 'attributes', '.', '-topmost', False)
        start_timer()
        mark = ""
        for i in range(reps//2):
            mark += "❤︎"
        check_marks.config(text=mark)


# Label Title
title_label = Label(text="Timer", fg=WORK_COLOR, bg=BACKGROUND, font=(FONT_NAME, 50))
title_label.grid(row=0, column=1)

# roughly same size as image
canvas = Canvas(width=250, height=253, bg=BACKGROUND, highlightthickness=0)

# Images
working_img = PhotoImage(file="/Users/pamela/Documents/Dev/python100/day28_pomodoro-gui/kirby_pomodoro_work.png")
short_break_img = PhotoImage(file="/Users/pamela/Documents/Dev/python100/day28_pomodoro-gui/kirby_pomodoro_shortbreak.png")
long_break_img = PhotoImage(file="/Users/pamela/Documents/Dev/python100/day28_pomodoro-gui/kirby_pomodoro_longbreak.png")

image_container = canvas.create_image(125, 90, image=working_img)
timer_text = canvas.create_text(125, 200, text="00:00", fill="white", font=(FONT_NAME, 35, "bold"))
canvas.grid(row=1, column=1)

# Button Start
start_button = Button(text="Start", font=FONT_NAME, highlightbackground=BACKGROUND, command=start_timer)
start_button.grid(row=2, column=0)

# Pomodoros count
check_marks = Label(text="", fg=CHECK_COLOR, bg=BACKGROUND)
check_marks.grid(row=3, column=1)

# Button Reset
reset_button = Button(text="Reset", font=FONT_NAME, highlightbackground=BACKGROUND, command=reset_pomodoro)
reset_button.grid(row=2, column=2)

window.mainloop()