import matplotlib
matplotlib.use('TkAgg')
import numpy as np
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
from tkinter import *
from sympy import *

def Plot():
    """Funkcja przechwituje z pola na wzór f(x) string i przy pomocy paru algorytmów, 
    przekonwertowywuje go na opis funkcji zrozumiałeś przez moduł sympy, który następnie określa tablicę do stworzenia wykresów.
    Dla większej ilości wzorów, rozdziela je dzięki zankowi ";" między nimi, a następnie tworzy kilka wykresów na raz
    """
    try:
        p=np.linspace(float(LX.get()),float(PX.get()),1000)
    except:
        p=np.linspace(-10,10,1000)
    wzory=[]
    string=s.get()
    a=0
    while True:
        try:
            b=string.index(";")
            wzory.append(string[a:b])
            string=string.replace(";","#",1)
            a=b+1
        except:
            wzory.append(string[a:])
            break

    fig = Figure(figsize=(6,6))
    wykresy = fig.add_subplot(111)

    for wzor in wzory:
        qi=[]
        ładnywzor=wzor
        wzor=wzor.replace("e","E")
        wzor=wzor.replace("^","**")
        if wzor.find("x")==-1:
            for i in range(1000):
                qi.append(eval(wzor))
        else:
            f=eval(wzor)
            for i in range(1000):
                qi.append(f.subs(x,p[i]).evalf())
                if qi[i]==zoo:
                    qi[i]=nan
                if str(qi[i]).find("I")!=-1:
                    qi[i]=nan
            for i in range(len(qi)-1):
                try:
                    if qi[i]*qi[i+1]<-2:
                        qi[i]=nan
                except:
                    pass
        wykresy.plot(p,qi,label=ładnywzor)
    
    wykresy.set_title (tytuł.get(), fontsize=16)
    wykresy.set_ylabel(OY.get(), fontsize=14)
    wykresy.set_xlabel(OX.get(), fontsize=14)
    try:
        wykresy.axis([float(LX.get()),float(PX.get()),float(LY.get()),float(PY.get())])
    except:
        pass
    wykresy.grid(True)
    if l.get()==1:
        wykresy.legend()
    canvas = FigureCanvasTkAgg(fig, master=window)
    canvas.get_tk_widget().pack(side=RIGHT)
    canvas.draw()

def tekst(okno,var,R,C,Width=5):
    '''Funkcja tworzy nowe okna tekstowe do wpisywania tekstu w zadanym Frame'ie.
    okno-wybór Frame'a; var - zmienna przechwytująca tekst, R - rząd w którym ma się znaleźć, C - kolumna w której ma się znaleźć, Width - szerokość pola na tekst'''
    entry = Entry(okno,width=Width, textvariable = var)
    entry.grid(row=R,column=C)

def etykieta(okno,txt,R,C,Width=5):
    '''Funkcja dodaje nowe pole z tekstem do isntniejącego Frame'a.
    okno-wybór Frame'a; txt - tekst do wstawienia; R - rząd w którym ma się znaleźć, C - kolumna w której ma się znaleźć, Width - szerokość pola na tekst'''
    label=Label(okno, text=txt, width=Width)
    label.grid(row=R,column=C)

def Quit():
    '''Funkcja zamykająca środowisko GUI'''
    window.destroy()

def piszSin():
    '''Funkcja dodaje do pola na f(x) "sin"'''
    s.set(s.get()+"sin")
def piszCos():
    '''Funkcja dodaje do pola na f(x) "cos"'''
    s.set(s.get()+"cos")
def piszTan():
    '''Funkcja dodaje do pola na f(x) "tan"'''
    s.set(s.get()+"tan")
def piszLn():
    '''Funkcja dodaje do pola na f(x) "log"'''
    s.set(s.get()+"log")
def piszSqrt():
    '''Funkcja dodaje do pola na f(x) "sqrt"'''
    s.set(s.get()+"sqrt")
def piszPow():
    '''Funkcja dodaje do pola na f(x) "^"'''
    s.set(s.get()+"^")
def piszPi():
    '''Funkcja dodaje do pola na f(x) "pi"'''
    s.set(s.get()+"pi")
def piszE():
    '''Funkcja dodaje do pola na f(x) "e"'''
    s.set(s.get()+"e")
def piszPlus():
    '''Funkcja dodaje do pola na f(x) "+"'''
    s.set(s.get()+"+")
def piszMinus():
    '''Funkcja dodaje do pola na f(x) "-"'''
    s.set(s.get()+"-")
def piszTime():
    '''Funkcja dodaje do pola na f(x) "*"'''
    s.set(s.get()+"*")
def piszBy():
    '''Funkcja dodaje do pola na f(x) "/"'''
    s.set(s.get()+"/")
def piszLeft():
    '''Funkcja dodaje do pola na f(x) "("'''
    s.set(s.get()+"(")
def piszRight():
    '''Funkcja dodaje do pola na f(x) ")"'''
    s.set(s.get()+")")
def piszX():
    '''Funkcja dodaje do pola na f(x) "x"'''
    s.set(s.get()+"x")
def piszŚred():
    '''Funkcja dodaje do pola na f(x) ";"'''
    s.set(s.get()+";")

init_printing()
window= Tk()
window.geometry("850x600+470+70")
window.title("wykresy")
x=Symbol("x")

s=StringVar()
frame = Frame(window)
frame.place(x=20,y=60)
button = Button (frame, text="sin", command=piszSin, width=5)
button.grid(row=0, column=0)
button2 = Button (frame, text="cos", command=piszCos, width=5)
button2.grid(row=0, column=1)
button3 = Button (frame, text="tan", command=piszTan, width=5)
button3.grid(row=0, column=2)
button4 = Button (frame, text="log", command=piszLn, width=5)
button4.grid(row=0, column=3)
button5 = Button (frame, text="sqrt", command=piszSqrt, width=5)
button5.grid(row=1, column=0)
button6 = Button (frame, text="^", command=piszPow, width=5)
button6.grid(row=1, column=1)
button7 = Button (frame, text="pi", command=piszPi, width=5)
button7.grid(row=1, column=2)
button8 = Button (frame, text="e", command=piszE, width=5)
button8.grid(row=1, column=3)
button9 = Button (frame, text="+", command=piszPlus, width=5)
button9.grid(row=2, column=0)
button10 = Button (frame, text="-", command=piszMinus, width=5)
button10.grid(row=2, column=1)
button11 = Button (frame, text="*", command=piszTime, width=5)
button11.grid(row=2, column=2)
button12 = Button (frame, text="/", command=piszBy, width=5)
button12.grid(row=2, column=3)
button13 = Button (frame, text="(", command=piszLeft, width=5)
button13.grid(row=3, column=0)
button14 = Button (frame, text=")", command=piszRight, width=5)
button14.grid(row=3, column=1)
button15 = Button (frame, text="x", command=piszX, width=5)
button15.grid(row=3, column=2)
button15 = Button (frame, text=";", command=piszŚred, width=5)
button15.grid(row=3, column=3)


frame2=Frame(window)
frame2.place(x=20,y=20)
tekst(frame2,s,0,0,21)
LICZ = Button (frame2, text="RYSUJ!", command=Plot, width=6)
LICZ.grid(row=0, column=2)

frame3=Frame(window)
frame3.place(x=20,y=180)
etykieta(frame3,"Tytuł wykresu",0,0,10)
etykieta(frame3,"Oś oX",1,0,4)
etykieta(frame3,"Oś oY",2,0,4)
tytuł=StringVar()
tekst(frame3,tytuł,0,1,17)
OX=StringVar()
tekst(frame3,OX,1,1,17)
OY=StringVar()
tekst(frame3,OY,2,1,17)

frame4=Frame(window)
frame4.place(x=20,y=270)
etykieta(frame4,"Zakres X",0,0,10)
etykieta(frame4,"Zakres Y",1,0,10)
LX=StringVar()
tekst(frame4,LX,0,1,8)
PX=StringVar()
tekst(frame4,PX,0,2,8)
LY=StringVar()
tekst(frame4,LY,1,1,8)
PY=StringVar()
tekst(frame4,PY,1,2,8)

l=IntVar()
legenda=Checkbutton(window,text="legenda",variable = l, width = 10)
legenda.place(x=20,y=330)

wyjdz = Button (window, text="WYJDŹ!", command=Quit, width=30, height=5)
wyjdz.grid(row=0, column=2)
wyjdz.place(x=20,y=490)

window.mainloop()