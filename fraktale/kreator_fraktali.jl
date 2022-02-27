using Gtk, Plots, Luxor

#-----------------------------------------------------------------------------------------------------------
# 1. Funkcje do tworzenia krzywych
#-----------------------------------------------------------------------------------------------------------

#---------------
# times table
#---------------

function times_table(k, N) # Część główna
    θ = LinRange(0, 2*pi, N) 
    
    Table = plot()

    ### Rysowanie linii
    for i in θ
        plot!([sin(i), sin(k*i)], [cos(i), cos(k*i)],
        label = "", 
        ratio = :equal,
        linecolor = [102,255,170],
        framestyle = :none
        )
    end

    ### Rysowanie punktów na okręgu
    scatter!(sin.(θ), cos.(θ), 
    markercolor = :black, 
    label = "", 
    ratio = :equal,
    markersize = 3,
    framestyle = :none
    ) 
    scatter!(annotations = (1, 1, Plots.text(string(round(k, digits=3)), :bottom, :black, 12)))
end

function times_table_image(k,N)  # Część tworząca obraz
    times_table(k, N)
    png("times_table_image")
end

function times_table_gif(start, stop, N, framerate) # Część tworząca gif,    k-start, k-stop, N, fps
    anim = @animate for i in start*framerate:stop*framerate 
        times_table(i/framerate, N)
    end
    gif(anim, "times_table.gif", fps = framerate)
end

#---------------
# logistic map
#---------------

function logistic_map(r1, r2) # Część główna
    r = LinRange(r1, r2, 2000)

    Tablica = zeros(2000, 300)
    Tablica[:,1] .= 0.5 #x1 = 0.5, start populacji

    for i in 2:300
        Tablica[:, i] .= r .* Tablica[:, i-1] .* (1 .- Tablica[:, i-1]) #xn = rxn-1(1-xn-1)
    end

    ### wyrysowanie ostatnich 100 iteracji
    scatter()
    for i in 1:100
        scatter!(r, Tablica[:, end-i], 
        label = nothing, 
        markersize = 0.1, 
        markercolor = :black,
        xlabel = "r",
        ylabel = "Population"
        )
    end
    scatter!(size=(800,600)) # IMAGE-SIZE
end

function logistic_map_image(r1,r2) # Część tworząca obraz
    logistic_map(r1, r2)
    png("logistic_map_image")
end

function logistic_map_gif(start, stop, duration, framerate) # Część tworząca gif,   r1-start, r2-stop, duration, fps
    anim = @animate for i in 1:duration*framerate
        logistic_map(start+ i*(stop-start)/(framerate*duration), 4)
    end
    gif(anim, "logistic_map.gif", fps = framerate)
end

#---------------
# hypocycloid
#---------------

function hypocycloid(k) # Część główna
    t = LinRange(0, 2*pi, 300)

    ### wyznaczam punkty z równań parametrycznych 
    x = ( (k-1)*cos.(t) + cos.((k-1)*t) )/k 
    y = ( (k-1)*sin.(t) - sin.((k-1)*t) )/k

    ### rysuje figurę (zeskalowana tak by leżała na kole o promieniu r=1)
    plot(x,y,
            linecolor = :red, 
            label = "", 
            ratio = :equal,
            framestyle = :none
            ) 

    ### rysuję koło
    plot!(sin.(t), cos.(t), 
            linecolor = :blue, 
            label = "", 
            ratio = :equal,
            framestyle = :none
            )
    scatter!(annotations = (1, 1, Plots.text(string(round(k, digits=3)), :bottom, :blue, 12)))
end

function hypocycloid_image(k) # Część tworząca obraz
    hypocycloid(k)
    png("hypocycloid_image")
end

function hypocycloid_gif(start, stop, framerate) # Część tworząca gif,   k-start, k-stop, fps
    anim = @animate for i in start*framerate:stop*framerate
        hypocycloid(i/framerate)
    end
    gif(anim, "hypocycloid.gif", fps = framerate)
end

#---------------
# superellipse
#---------------

function superellipse(a, b, n) # Część główna
    t = LinRange(0, pi/2, 100)

    ### wyznaczam punkty z równań parametrycznych 
    x = a*cos.(t).^(2/n)
    y = b*sin.(t).^(2/n)

    ### Powstałą 1/4 krzywej sklejam w całość
    X = [reverse(x); x; -reverse(x); -x]
    Y = [-reverse(y); y; reverse(y); -y]

    ### rysuję krzywą
    plot(X,Y, 
    linecolor = :red, 
    label = "", 
    ratio = :equal,
    markersize = 3,
    framestyle = :origin
    ) 
    scatter!(annotations = (a, b, Plots.text(string(round(n, digits=3)), :bottom, :blue, 12)))
end

function superellipse_image(a, b, n) # Część tworząca obraz
    superellipse(a, b, n)
    png("superellipse_image")
end

function superellipse_gif(a, b, start, stop, duration, framerate) # Część tworząca gif,   a,b - parametry,  n-start, n-stop, duration, fps
    anim = @animate for i in 1:duration*framerate
        superellipse(a, b, start + i*(stop-start)/(framerate*duration))
    end
    gif(anim, "superellipse.gif", fps = framerate)
end

#---------------
# Hilbert's curve
#---------------

function draw_hilbert(Iterations)
    Drawing(2^(Iterations+2), 2^(Iterations+2), "hilbert.png")

    🐢 = Turtle()
    Reposition(🐢, 2, 2) 
    Pencolor(🐢, "cyan")
    Penwidth(🐢, 1)
    function hilbert(iter, angle)
        iter == 0 && return

        HueShift(🐢, 1/Iterations)

        Turn(🐢, angle)
        hilbert(iter-1, -angle)

        Forward(🐢, 4)
        Turn(🐢, -angle)
        hilbert(iter-1, angle)

        Forward(🐢, 4)
        hilbert(iter-1, angle)

        Turn(🐢, -angle)
        Forward(🐢, 4)
        hilbert(iter-1, -angle)

        Turn(🐢, angle)
    end

    setline(2)
    setlinecap("round")

    hilbert(Iterations,90)
    finish()
end

#---------------
# C Levy curve
#---------------

function draw_levy(Iterations)
    SCREENHEIGHT = round(9*1.41^(Iterations))
    SCREENWIDTH = round(9*1.41^(Iterations))
    Drawing(SCREENWIDTH, SCREENHEIGHT, "clevycurve.png")
    
    🐢 = Turtle()
    Reposition(🐢, SCREENWIDTH*0.7,SCREENHEIGHT*4/7 )

    Turn(🐢, 45*(-2-Iterations))
    Pencolor(🐢, "cyan")
    Penwidth(🐢, 1.5)

    function levy(iter, turn)
        iter < 0 && return
        iter == 0 && Forward(🐢, 4)

        HueShift(🐢, 0.03)

        if turn == "left"
            Turn(🐢, 90)
        elseif turn == "right"
            Turn(🐢, -90)
    
        end
        
        levy(iter-1,"left")
        Turn(🐢, -90)
        levy(iter-1,"right")
        
    end
    
    setline(2)
    setlinecap("round")

    levy(Iterations,1)
    finish()
end


#---------------
# Koch curve
#---------------

function kochLista(a)
    lista=[2,1,2]
    lista2=[]
    if a==2
        lista2=lista
    elseif a>2
        lista3=kochLista(a-1)
        for i in lista
            for j in lista3
                append!(lista2,j)
            end
            append!(lista2,i)
        end
        for i in lista3
            append!(lista2,i)
        end
    end
    return lista2
end

function kochLength(y,angle)
    if y==1
        x=600/(2(cos((pi-2*pi*angle/360)/2)+1))
    else
        x=kochLength(y-1,angle)/(2(cos((pi-2*pi*angle/360)/2)+1))
    end
    return x
end


function draw_koch(iter, angle)
    Drawing(840, 920, "koch.png")
    origin()
    zolw = Turtle()
    Reposition(zolw, -300, -110)
    Pencolor(zolw, "cyan")
    Penwidth(zolw, 3)
    angle1=180-angle
    angle2=-(180-angle)/2
    x=kochLength(iter,angle)
    lista=kochLista(iter)

    for k in 1:3
        for i in 1:4^(iter-1)-1
            Forward(zolw,x)
            Turn(zolw,angle2)
            Forward(zolw,x)
            Turn(zolw,angle1)
            Forward(zolw,x)
            Turn(zolw,angle2)
            Forward(zolw,x)
            if length(lista)>0
                if lista[i]==2
                    Turn(zolw,angle2)
                else
                    Turn(zolw,angle1)
                end
            end
        end
        Forward(zolw,x)
        Turn(zolw,angle2)
        Forward(zolw,x)
        Turn(zolw,angle1)
        Forward(zolw,x)
        Turn(zolw,angle2)
        Forward(zolw,x)
        Turn(zolw,120)
    end
    
    setline(2)
    setlinecap("round")
    finish()
end

#---------------
# Dragon curve
#---------------

function draw_dragon(iter, angle)

    SCREENHEIGHT = round(7*1.414^(iter))
    SCREENWIDTH = round(7*1.414^(iter))
    Drawing(SCREENWIDTH, SCREENHEIGHT, "dragon.png")
    
    zolw = Turtle()
    Reposition(zolw, SCREENWIDTH*( (0.5-1/3)/3 + 1/(3*1.5)), SCREENHEIGHT/2 )

    Turn(zolw, -45*(iter))
    Pencolor(zolw, "cyan")
    Penwidth(zolw, 1.5)

    old=[angle]
    for i in 1:iter-1
        append!(old,angle)
        len=length(old)
        for i in 1:len-1
            append!(old,-old[len-i])
        end     
    end
    for i in 1:length(old)        
        Forward(zolw, 4)

        HueShift(zolw, 0.03)

        Turn(zolw,old[i])
    end
    Forward(zolw,4)

    setline(2)
    setlinecap("round")
    
    finish()
end

#-----------------------------------------------------------------------------------------------------------------------------------------------
# 2. Funkcje pod przyciskami w gui; na zmianę przycisk otwierający parametry i przycisk tworzący obrazek krzywej
#-----------------------------------------------------------------------------------------------------------------------------------------------

#---------------
# times table GUI
#---------------

### Część do obrazka
function window_times_table(widget) 
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Times table image")
    button_show = GtkButton("Pokaż")    
    global k_scale = GtkScale(false, 0:100)
    global N_scale = GtkScale(false, 50:300)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

Parametry:
1. k - mnożnik;
2. N - ilość punktów na okręgu.

Uwagi: 
Zaleca się używanie N>=200 dla lepszego efektu.
Dla N=200 i każdych kolejnych k  możemy zaobserwować krzywe - epicykloidy,
k=2 daje kardioidę, k=3 daje nefroidę itd... 
Polecam k=99 N=200.")
    second_grid[1,1]=title_label
    second_grid[1,2]=k_scale
    second_grid[1,3]=N_scale
    second_grid[1,4]=button_show
    second_grid[1,5:8]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_times_table, button_show, "clicked")
    showall(window)
end

function output_times_table(widget) 
    wart_k_scale = Int64(Gtk.GAccessor.value(k_scale))
    wart_N_scale = Int64(Gtk.GAccessor.value(N_scale))
    destroy(second_grid)
    global second_grid = GtkGrid()
    times_table_image(wart_k_scale,wart_N_scale)
    image = GtkImage("times_table_image.png")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

### Część do gifa
function window_times_table_gif(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Times table gif")
    button_show = GtkButton("Pokaż")    
    global kstart_scale = GtkScale(false, 0:100)
    global kstop_scale = GtkScale(false, 0:100)
    global N_scale = GtkScale(false, 50:300)
    global fps_scale = GtkScale(false, 1:30)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. k1 - mnożnik od którego startujemy;
    2. k2 - mnożnik na którym animacja ma się zakończyć;
    3. N - ilość punktów na okręgu;
    4. FPS - ilość klatek na sekundę jaką ma mieć animacja.
    
    Uwagi: 
    k2 musi być większe od k1.
    Zaleca się używanie N>=200 dla lepszego efektu.
    Dla k>30 możemy zauważyć wiele intrygujących struktur.
    WAŻNE: Animacja potrafi długo się robić, dla |k2-k1|=10 N=200 FPS=10 zajmuje to 20s.
    Polecam k1=0 k2=5 N=200 fps=20.")
    second_grid[1,1]=title_label
    second_grid[1,2]=kstart_scale
    second_grid[1,3]=kstop_scale
    second_grid[1,4]=N_scale
    second_grid[1,5]=fps_scale
    second_grid[1,6]=button_show
    second_grid[1,7:8]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_times_table_gif, button_show, "clicked")
    showall(window)
end

function output_times_table_gif(widget)
    wart_kstart_scale = Int64(Gtk.GAccessor.value(kstart_scale))
    wart_kstop_scale = Int64(Gtk.GAccessor.value(kstop_scale))
    wart_N_scale = Int64(Gtk.GAccessor.value(N_scale))
    wart_fps_scale = Int64(Gtk.GAccessor.value(fps_scale))
    destroy(second_grid)
    global second_grid = GtkGrid()
    times_table_gif(wart_kstart_scale, wart_kstop_scale, wart_N_scale, wart_fps_scale)
    image = GtkImage("times_table.gif")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

#---------------
# logistic map GUI
#---------------

### Część do obrazka
function window_logistic_map(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Logistic map image")
    button_show = GtkButton("Pokaż")    
    global r1_scale = GtkScale(false, -2:0.01:4)
    global r2_scale = GtkScale(false, -2:0.01:4)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. r1 - lewa część zakresu na którym rysowany jest diagram bifurkacyjny;
    2. r2 - prawa część zakresu na którym rysowany jest diagram bifurkacyjny.
    
    Uwagi: 
    Jeżeli r1>r2 to rola zakresów się odwraca.
    W zakresie 3.4-4 można zauważyć linie krytyczne.
    Zaleca się używanie r>3 z racji, że wcześniej nie ma nic ciekawego, a część między -2 i -1 jest odwróconą i zeskalowaną częścią r>3.")
    second_grid[1,1]=title_label
    second_grid[1,2]=r1_scale
    second_grid[1,3]=r2_scale
    second_grid[1,4]=button_show
    second_grid[1,5:8]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_logistic_map, button_show, "clicked")
    showall(window)
end

function output_logistic_map(widget)
    wart_r1_scale = Gtk.GAccessor.value(r1_scale)
    wart_r2_scale = Gtk.GAccessor.value(r2_scale)
    destroy(second_grid)
    global second_grid = GtkGrid()
    logistic_map_image(wart_r1_scale,wart_r2_scale)
    image = GtkImage("logistic_map_image.png")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

### Część do gifa
function window_logistic_map_gif(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Logistic map gif")
    button_show = GtkButton("Pokaż")    
    global r1_scale = GtkScale(false, -2:0.01:4)
    global r2_scale = GtkScale(false, -2:0.01:4)
    global duration_scale = GtkScale(false, 1:20)
    global fps_scale = GtkScale(false, 1:30)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. r1 - lewa część zakresu od której zaczyna się animacja;
    2. r2 - lewa część zakresu na której kończy się animacja (prawa część zakresu to zawsze r=4);
    3. duration - długość trwania animacji w sekundach;
    4. FPS - ilość klatek na sekundę jaką ma mieć animacja.

    Uwagi: 
    Jeżeli r1>r2 to rola zakresów się odwraca oraz animacja jest grana wstecz.
    W zakresie 3.4-4 można zauważyć linie krytyczne.
    Zaleca się używanie r>3 z racji, że funkcja zmierza ku wartości r=4.
    WAŻNE: Animacja potrafi długo się robić, dla duraton=5s FPS=10 zajmuje to 30s.
    ")
    second_grid[1,1]=title_label
    second_grid[1,2]=r1_scale
    second_grid[1,3]=r2_scale
    second_grid[1,4]=duration_scale
    second_grid[1,5]=fps_scale
    second_grid[1,6]=button_show
    second_grid[1,7:8]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_logistic_map_gif, button_show, "clicked")
    showall(window)
end

function output_logistic_map_gif(widget)
    wart_r1_scale = Gtk.GAccessor.value(r1_scale)
    wart_r2_scale = Gtk.GAccessor.value(r2_scale)
    wart_duration_scale = Int64(Gtk.GAccessor.value(duration_scale))
    wart_fps_scale = Int64(Gtk.GAccessor.value(fps_scale))
    destroy(second_grid)
    global second_grid = GtkGrid()
    logistic_map_gif(wart_r1_scale, wart_r2_scale, wart_duration_scale, wart_fps_scale)
    image = GtkImage("logistic_map.gif")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

#---------------
# hypocycloid GUI
#---------------

### Część do obrazka
function window_hypocycloid(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Hypocycloid image")
    button_show = GtkButton("Pokaż")    
    global k_scale = GtkScale(false, 2:50)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. k - ilość 'boków' hypocykloidu.")
    second_grid[1,1]=title_label
    second_grid[1,2]=k_scale
    second_grid[1,3]=button_show
    second_grid[1,4:8]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_hypocycloid, button_show, "clicked")
    showall(window)
end

function output_hypocycloid(widget)
    wart_k_scale = Int64(Gtk.GAccessor.value(k_scale))
    destroy(second_grid)
    global second_grid = GtkGrid()
    hypocycloid_image(wart_k_scale)
    image = GtkImage("hypocycloid_image.png")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

### Część do gifa
function window_hypocycloid_gif(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Hypocycloid gif")
    button_show = GtkButton("Pokaż")    
    global kstart_scale = GtkScale(false, 2:50)
    global kstop_scale = GtkScale(false, 2:50)
    global fps_scale = GtkScale(false, 1:30)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. k1 - ilość 'boków' hypocykloidu od którego zaczynamy animację;
    2. k2 - ilość 'boków' hypocykloidu na którym kończymy animację;
    3. FPS - ilość klatek na sekundę jaką ma mieć animacja.
    
    Uwagi:
    k2 musi być większe od k1.")
    second_grid[1,1]=title_label
    second_grid[1,2]=kstart_scale
    second_grid[1,3]=kstop_scale
    second_grid[1,4]=fps_scale
    second_grid[1,5]=button_show
    second_grid[1,6:8]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_hypocycloid_gif, button_show, "clicked")
    showall(window)
end

function output_hypocycloid_gif(widget)
    wart_kstart_scale = Int64(Gtk.GAccessor.value(kstart_scale))
    wart_kstop_scale = Int64(Gtk.GAccessor.value(kstop_scale))
    wart_fps_scale = Int64(Gtk.GAccessor.value(fps_scale))
    destroy(second_grid)
    global second_grid = GtkGrid()
    hypocycloid_gif(wart_kstart_scale, wart_kstop_scale, wart_fps_scale)
    image = GtkImage("hypocycloid.gif")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

#---------------
# superellipse GUI
#---------------

### Część do obrazka
function window_superellipse(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Superellipse image")
    button_show = GtkButton("Pokaż")    
    global a_scale = GtkScale(false, 1:20)
    global b_scale = GtkScale(false, 1:20)
    global n_scale = GtkScale(false, 0.1:0.1:10)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. a - półoś wielka;
    2. b - półoś mała;
    3. n - stopień krzywej.
    
    Uwagi:
    Dla n=2 mamy normalne elipsy.")
    second_grid[1,1]=title_label
    second_grid[1,2]=a_scale
    second_grid[1,3]=b_scale
    second_grid[1,4]=n_scale
    second_grid[1,5]=button_show
    second_grid[1,6:8]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_superellipse, button_show, "clicked")
    showall(window)
end

function output_superellipse(widget)
    wart_a_scale = Int64(Gtk.GAccessor.value(a_scale))
    wart_b_scale = Int64(Gtk.GAccessor.value(b_scale))
    wart_n_scale = Gtk.GAccessor.value(n_scale)
    destroy(second_grid)
    global second_grid = GtkGrid()
    superellipse_image(wart_a_scale, wart_b_scale, wart_n_scale)
    image = GtkImage("superellipse_image.png")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

### Część do gifa
function window_superellipse_gif(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Superellipse gif")
    button_show = GtkButton("Pokaż")    
    global a_scale = GtkScale(false, 1:20)
    global b_scale = GtkScale(false, 1:20)
    global nstart_scale = GtkScale(false, 0.1:0.1:10)
    global nstop_scale = GtkScale(false, 0.1:0.1:10)
    global duration_scale = GtkScale(false, 1:20)
    global fps_scale = GtkScale(false, 1:30)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. a - półoś wielka;
    2. b - półoś mała;
    3. n1 - stopień krzywej od której zaczynamy animację;
    4. n2 - stopień krzywej na której kończymy animację;
    5. duration - długość trwania animacji w sekundach;
    6. FPS - ilość klatek na sekundę jaką ma mieć animacja.")
    second_grid[1,1]=title_label
    second_grid[1,2]=a_scale
    second_grid[1,3]=b_scale
    second_grid[1,4]=nstart_scale
    second_grid[1,5]=nstop_scale
    second_grid[1,6]=duration_scale
    second_grid[1,7]=fps_scale
    second_grid[1,8]=button_show
    second_grid[1,9]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_superellipse_gif, button_show, "clicked")
    showall(window)
end

function output_superellipse_gif(widget)
    wart_a_scale = Int64(Gtk.GAccessor.value(a_scale))
    wart_b_scale = Int64(Gtk.GAccessor.value(b_scale))
    wart_nstart_scale = Gtk.GAccessor.value(nstart_scale)
    wart_nstop_scale = Gtk.GAccessor.value(nstop_scale)
    wart_duration_scale = Int64(Gtk.GAccessor.value(duration_scale))
    wart_fps_scale = Int64(Gtk.GAccessor.value(fps_scale))
    destroy(second_grid)
    global second_grid = GtkGrid()
    superellipse_gif(wart_a_scale, wart_b_scale, wart_nstart_scale, wart_nstop_scale, wart_duration_scale, wart_fps_scale)
    image = GtkImage("superellipse.gif")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

#---------------
# Hilbert's curve GUI
#---------------

function window_hilbert(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Hilbert's curve")
    button_show = GtkButton("Pokaż")    
    global iter_scale = GtkScale(false, 1:7)

    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. iter - ilość iteracji.
    ")
    second_grid[1,1]=title_label
    second_grid[1,2]=iter_scale
    second_grid[1,3]=button_show
    second_grid[1,4:6]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_hilbert, button_show, "clicked")
    showall(window)
end

function output_hilbert(widget)
    wart_iter_scale = Int64(Gtk.GAccessor.value(iter_scale))
  
    destroy(second_grid)
    global second_grid = GtkGrid()
    draw_hilbert(wart_iter_scale)
    image = GtkImage("hilbert.png")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

#---------------
# C Levy curve GUI
#---------------

function window_levy(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("C Levy curve")
    button_show = GtkButton("Pokaż")    
    global iter_scale = GtkScale(false, 1:13)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. iter - ilość iteracji.")
    second_grid[1,1]=title_label
    second_grid[1,2]=iter_scale
    second_grid[1,3]=button_show
    second_grid[1,4:6]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_levy, button_show, "clicked")
    showall(window)
end

function output_levy(widget)
    wart_iter_scale = Int64(Gtk.GAccessor.value(iter_scale))
  
    destroy(second_grid)
    global second_grid = GtkGrid()
    draw_levy(wart_iter_scale)
    image = GtkImage("clevycurve.png")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

#---------------
# Koch curve GUI
#---------------

function window_koch(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Koch curve")
    button_show = GtkButton("Pokaż")    
    global iter_scale = GtkScale(false, 1:9)
    global angle_scale = GtkScale(false, 0:360)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. iter - ilość iteracji;
    2. angle - kąt między dwoma środkowymi odcinkami 'nasienia', którym zastępuje się każdą linię w kolejnych iteracjach.
    
    Uwagi:
    Dla angle=60 otrzymujemy znany nam płatek.
    Dla angle=0 otrzymujemy nową space filling curve.
    Dla angle=300 otrzymujemy anty-płatek kocha.
    Dla angle=360 otrzymujemy wypełniony trójkąt równoboczny.
    Polecam angle=10." )
    second_grid[1,1]=title_label
    second_grid[1,2]=iter_scale
    second_grid[1,3]=angle_scale
    second_grid[1,4]=button_show
    second_grid[1,5:6]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_koch, button_show, "clicked")
    showall(window)
end

function output_koch(widget)
    wart_iter_scale = Int64(Gtk.GAccessor.value(iter_scale))
    wart_angle_scale = Int64(Gtk.GAccessor.value(angle_scale))
    destroy(second_grid)
    global second_grid = GtkGrid()
    draw_koch(wart_iter_scale,wart_angle_scale)
    image = GtkImage("koch.png")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end

#---------------
# Dragon curve GUI
#---------------

function window_dragon(widget)
    destroy(second_grid)
    global second_grid = GtkGrid()
    title_label = GtkLabel("Dragon curve")
    button_show = GtkButton("Pokaż")    
    global iter_scale = GtkScale(false, 1:14)
    description_label = GtkLabel("\nInstrukcja obsługi/uwagi:

    Parametry:
    1. iter - ilość iteracji.")
    second_grid[1,1]=title_label
    second_grid[1,2]=iter_scale
    second_grid[1,3]=button_show
    second_grid[1,4:6]=description_label
    set_gtk_property!(second_grid, :column_homogeneous, true)
    main_grid[3:5,1:6]=second_grid
    id = signal_connect(output_dragon, button_show, "clicked")
    showall(window)
end

function output_dragon(widget)
    wart_iter_scale = Int64(Gtk.GAccessor.value(iter_scale))
    destroy(second_grid)
    global second_grid = GtkGrid()
    draw_dragon(wart_iter_scale,90)
    image = GtkImage("dragon.png")
    second_grid[1,1]=image
    main_grid[3:5,1:6]=second_grid
    set_gtk_property!(second_grid, :column_homogeneous, true)
    set_gtk_property!(second_grid, :row_homogeneous, true)
    showall(window)
end


#-----------------------------------------------------------------------------------------------------------------------------------------------
# 3. GUI
#-----------------------------------------------------------------------------------------------------------------------------------------------

window = GtkWindow("Wybrane krzywe matematyczne",1500,1000) # ( nazwa, 1000, 600) ROZMIARY OKNA MOŻNA ZMIENIĆ JEŚLI TRZEBA
main_grid = GtkGrid()

### buttony wyboru krzywej
button_times_table = GtkButton("Times table mod k")
button_logistic_map = GtkButton("Logistic map")
button_hypocycloid = GtkButton("Hypocycloid")
button_superellipse = GtkButton("Superellipse")
button_hilbert_curve = GtkButton("Hilbert's curve")
button_koch_curve = GtkButton("Koch snowflake")
button_levy_curve = GtkButton("C Levy curve")
button_dragon_curve = GtkButton("Dragon curve")
button_times_table_gif = GtkButton("Times table gif")
button_logistic_map_gif = GtkButton("Logistic map gif")
button_hypocycloid_gif = GtkButton("Hypocycloid gif")
button_superellipse_gif = GtkButton("Superellipse gif")

second_grid= GtkGrid()
start_label = GtkLabel("Witaj w aplikacji, dzięki której możesz
poznać wybrane matematyczne krzywe.
Żeby zacząć, kliknij w wybrany przycisk z lewej strony ekranu.")
second_grid[1,1]=start_label
set_gtk_property!(second_grid, :column_homogeneous, true)
set_gtk_property!(second_grid, :row_homogeneous, true)

### zdefiniowanie akcji wykonanej po kliknięciu wybranego buttona
id = signal_connect(window_times_table, button_times_table, "clicked")
id = signal_connect(window_logistic_map, button_logistic_map, "clicked")
id = signal_connect(window_hypocycloid, button_hypocycloid, "clicked")
id = signal_connect(window_superellipse, button_superellipse, "clicked")
id = signal_connect(window_hilbert, button_hilbert_curve, "clicked")
id = signal_connect(window_levy, button_levy_curve, "clicked")
id = signal_connect(window_koch, button_koch_curve, "clicked")
id = signal_connect(window_dragon, button_dragon_curve, "clicked")
id = signal_connect(window_times_table_gif, button_times_table_gif, "clicked")
id = signal_connect(window_logistic_map_gif, button_logistic_map_gif, "clicked")
id = signal_connect(window_hypocycloid_gif, button_hypocycloid_gif, "clicked")
id = signal_connect(window_superellipse_gif, button_superellipse_gif, "clicked")

### grid
main_grid[1,1] = button_times_table
main_grid[1,2] = button_logistic_map
main_grid[1,3] = button_hypocycloid
main_grid[1,4] = button_superellipse
main_grid[1,5] = button_hilbert_curve
main_grid[1,6] = button_koch_curve
main_grid[2,5] = button_levy_curve
main_grid[2,6] = button_dragon_curve
main_grid[2,1] = button_times_table_gif
main_grid[2,2] = button_logistic_map_gif
main_grid[2,3] = button_hypocycloid_gif
main_grid[2,4] = button_superellipse_gif
main_grid[3:5,1:6]=second_grid

set_gtk_property!(main_grid, :column_homogeneous, true)
set_gtk_property!(main_grid, :row_homogeneous, true)
set_gtk_property!(main_grid, :column_spacing, 15)
set_gtk_property!(main_grid, :row_spacing, 15) 
push!(window, main_grid)
showall(window)

