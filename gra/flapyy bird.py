import pygame, os.path, time, random, sys, os
from pygame.locals import *


#zmienne pomocnicze
SCREEN_WIDTH = 617
SCREEN_HEIGHT = 800

#klasa ptaka, którym steruje gracz
class Bird(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image = loadImage("ptak.jpg")
        self.rect = self.image.get_rect()
        self.rect.center = (0.3*SCREEN_WIDTH,SCREEN_HEIGHT/2)
        self.motion = 0
        self.timeOfClick = 0

    def time(self):
        self.timeOfClick = time.time()

    def update(self,easy=False):

        t=time.time()-self.timeOfClick
        self.rect.move_ip((0,-(14 *self.motion-20*t*self.motion)))

        if easy:
            if self.rect.top <= 0:
                self.rect.top = 0
            elif self.rect.bottom >= SCREEN_HEIGHT:
                self.rect.bottom = SCREEN_HEIGHT

#klasa przeszkody typu słup dolny
class BottomPole(pygame.sprite.Sprite):
    def __init__(self, height):
        pygame.sprite.Sprite.__init__(self)
        self.image = loadImage("słupDół.jpg")
        self.rect = self.image.get_rect()
        self.rect.center = (SCREEN_WIDTH*1.1,height)
        self.velocity = 0

    def update(self):
        if self.rect.right <= 0:
            self.kill()
        else:
            self.rect.move_ip((-4,0))

#klasa przeszkody typu słup górny
class TopPole(pygame.sprite.Sprite):
    def __init__(self, height):
        pygame.sprite.Sprite.__init__(self)
        self.image = loadImage("słupGóra.jpg")
        self.rect = self.image.get_rect()
        self.rect.center = (SCREEN_WIDTH*1.1,height)
        self.velocity = 0

    def update(self):
        if self.rect.right <= 0:
            self.kill()
        else:
            self.rect.move_ip((-4,0))

#klasa pomocnicza krawędzi ekranu, służąca jako pomoc do warunku przegrywania w zderzeniu z nią,
#a w trybie "EASY" do przytrzymywania ptaka w ekranie
class Edge(pygame.sprite.Sprite):
    def __init__(self, height):
        pygame.sprite.Sprite.__init__(self)
        self.image = loadImage("tło.jpg")
        self.rect = self.image.get_rect()
        self.rect.center = (SCREEN_WIDTH/2,height)

    def update(self):
        pass

#klasa licznika punktów
class ScoreBoard(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.score = 0
        self.text = str(self.score)
        self.font = pygame.font.SysFont(None,50)
        self.image = self.font.render(self.text,1,(255,0,0))
        self.rect = self.image.get_rect()
        self.rect.center = (10,30)
        self.counter = -40

    def update(self):
        self.counter += 1
        if self.counter >=100:
            self.score += 1
            self.counter=0
        self.text = str(self.score)
        self.image = self.font.render(self.text,1,(255,0,0))
        self.rect = self.image.get_rect()
        self.rect.center = (30,30)

#klasa licznika żyć
class Lifes(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.counter = 3
        self.text = "Lifes: " + str(self.counter)
        self.font = pygame.font.SysFont(None,50)
        self.image = self.font.render(self.text,1,(255,0,0))
        self.rect = self.image.get_rect()
        self.rect.center = (SCREEN_WIDTH-80,30)

    def update(self):
        #self.counter -= 1
        self.text = "Lifes: " + str(self.counter)
        self.image = self.font.render(self.text,1,(255,0,0))
        self.rect = self.image.get_rect()
        self.rect.center = (SCREEN_WIDTH-80,30)

    def decrease(self):
        self.counter -= 1

#funkcja do ładowania grafik
def loadImage(name):
    fullname = os.path.join("media",name)
    image = pygame.image.load(fullname)
    image = image.convert()
    return image

#funkcja do ładowania dźwięków
def loadSound(name):
    fullname = os.path.join("media",name)
    sound = pygame.mixer.Sound(fullname)
    return sound

#funkcja do tworzenia tekstów w menu i zakładkach
def Text(text, x, y):
    textBox = pygame.font.SysFont(None,50).render(text,1,(35,177,77))
    textRect = textBox.get_rect()
    textRect.center = (x, y)
    screen.blit(textBox, textRect)

#funkjca do odpalania głównego menu gry
def menu():
    while True:
        screen.fill((154,217,234))

        mx, my = pygame.mouse.get_pos()

        button1= pygame.Rect(90,170,200,50)
        button2= pygame.Rect(310,170,200,50)
        button3= pygame.Rect(200,230,200,50)
        button4= pygame.Rect(200,290,200,50)
        button5= pygame.Rect(200,350,200,50)
        button6= pygame.Rect(200,410,200,50)
        
        pygame.draw.rect(screen, (255,0,0), button1)
        pygame.draw.rect(screen, (255,0,0), button2)
        pygame.draw.rect(screen, (255,0,0), button3)
        pygame.draw.rect(screen, (255,0,0), button4)
        pygame.draw.rect(screen, (255,0,0), button5)
        pygame.draw.rect(screen, (255,0,0), button6)

        Text("Graj w trybie:",300,135)
        Text("EASY",190,195)
        Text("HARD",410,195)
        Text("Zasady",300,255)
        Text("Highscores",300,315)
        Text("O autorze",300,375)
        Text("Zakończ",300,435)
       
        click = False

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == MOUSEBUTTONDOWN:
                if event.button == 1:
                    click = True

        if button1.collidepoint((mx,my)):
            if click:
                easygame()
        elif button2.collidepoint((mx,my)):
            if click:
                game()
        elif button3.collidepoint((mx,my)):
            if click:
                rulls()
        elif button4.collidepoint((mx,my)):
            if click:
                highscore()
        elif button5.collidepoint((mx,my)):
            if click:
                author()
        elif button6.collidepoint((mx,my)):
            if click:
                pygame.quit()
                sys.exit()
                    
        pygame.display.flip()

#funkjca do inicjalizowania gry
def game():
    pygame.mixer.pre_init(44100,-16,1,512)
    pygame.init()

    #stworzenie okna gry
    screen = pygame.display.set_mode((SCREEN_WIDTH,SCREEN_HEIGHT)) 
    pygame.display.set_caption("Flappy Bird")

    #załadowanie grafiki na tło
    background_image = loadImage("tło.jpg")
    screen.blit(background_image,(0,0))

    #stworzenie Sprite'a ptaka
    birdSprite = pygame.sprite.RenderClear() 
    bird = Bird()                       
    birdSprite.add(bird)

    #stworzenie Sprite'a dla dolnych słupków
    bottomPolesSprites = pygame.sprite.RenderClear()
    bottomPolesSprites.add(BottomPole(850))
    
    #stworzenie Sprite'a dla górnych słupków
    topPolesSprites = pygame.sprite.RenderClear()
    topPolesSprites.add(TopPole(-120))

    #stworzenie Sprite'a dla krawędzi ekranu
    edgesSprites = pygame.sprite.RenderClear()
    edgesSprites.add(Edge(-SCREEN_HEIGHT*0.5-20))
    edgesSprites.add(Edge(SCREEN_HEIGHT*1.5+23))

    #stworzenie Sprite'a licznika punktów
    scoreboardSprite = pygame.sprite.RenderClear()
    scoreboard=ScoreBoard()
    scoreboardSprite.add(scoreboard)

    #załadowanie potrzebnych dźwięków
    birdFX = loadSound("trzepot.wav")
    lostFX = loadSound("przegrana.wav")

    prerunning = True
    running = True
    PolesCounter=0
    clock = pygame.time.Clock()

    #pętla początkowa kończy się po kliknięciu spacji, potem uruchamia się właściwa pętla gry
    while prerunning:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == KEYDOWN:
                if event.key == K_SPACE:
                    birdFX.play()
                    bird.motion = 1
                    bird.time()
                    prerunning = False
        
        birdSprite.update()
        birdSprite.clear(screen, background_image)
        birdSprite.draw(screen)
        pygame.display.flip()

    #właściwa pętla gry
    while running:
        clock.tick(40)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == KEYDOWN:
                if event.key == K_SPACE:
                    birdFX.play()
                    bird.motion = 1
                    bird.time()
                    

        #pojawianie się nowych słupków
        PolesCounter += 1
        if PolesCounter >= 100:
            rand = random.randrange(-200,200)
            bottomPolesSprites.add(BottomPole(rand+850))
            topPolesSprites.add(TopPole(rand-120))
            PolesCounter = 0       


                     
        #aktualizacja wszystkich sprite'ów
        birdSprite.update()
        bottomPolesSprites.update()
        topPolesSprites.update()
        scoreboardSprite.update()

        #zderzenie ptaka ze słupkiem przerwya grę i zapisuje wynik do pliku
        for hit in pygame.sprite.groupcollide(topPolesSprites,birdSprite,0,0):
            file=open("wyniki.txt",'a')
            file.write(str(scoreboard.score)+"\n")
            file.close()
            lostFX.play()
            time.sleep(0.5)
            lose(str(scoreboard.score))
            running = False

        #zderzenie ptaka ze słupkiem przerwya grę i zapisuje wynik do pliku
        for hit in pygame.sprite.groupcollide(bottomPolesSprites,birdSprite,0,0):
            file=open("wyniki.txt",'a')
            file.write(str(scoreboard.score)+"\n")
            file.close()
            lostFX.play()
            time.sleep(0.5)
            lose(str(scoreboard.score))
            running = False

        for hit in pygame.sprite.groupcollide(topPolesSprites,scoreboardSprite,0,0):
            pass

        for hit in pygame.sprite.groupcollide(topPolesSprites,edgesSprites,0,0):
            pass

        for hit in pygame.sprite.groupcollide(bottomPolesSprites,edgesSprites,0,0):
            pass

        #zderzenie ptaka ze krawędzią okna przerwya grę i zapisuje wynik do pliku
        for hit in pygame.sprite.groupcollide(birdSprite,edgesSprites,0,0):
            file=open("wyniki.txt",'a')
            file.write(str(scoreboard.score)+"\n")
            lostFX.play()
            file.close()
            time.sleep(0.5)
            lose(str(scoreboard.score))
            running = False

        #czyszczenie ekranu
        birdSprite.clear(screen, background_image)
        bottomPolesSprites.clear(screen, background_image)
        topPolesSprites.clear(screen, background_image)
        scoreboardSprite.clear(screen, background_image)
        edgesSprites.clear(screen, background_image)

        #rysowanie sprite'ów
        birdSprite.draw(screen)
        bottomPolesSprites.draw(screen)
        topPolesSprites.draw(screen)
        scoreboardSprite.draw(screen)
        edgesSprites.draw(screen)
        
        pygame.display.flip()

#funkcja do inicjalizowania gry w trybie "EASY", bardzo podobna do funkcji game()
def easygame():
    pygame.mixer.pre_init(44100,-16,1,512)
    pygame.init()

    #stworzenie okna gry
    screen = pygame.display.set_mode((SCREEN_WIDTH,SCREEN_HEIGHT)) 
    pygame.display.set_caption("Flappy Bird")
    
    #załadowanie grafiki na tło
    background_image = loadImage("tło.jpg")
    screen.blit(background_image,(0,0))

    #stworzenie Sprite'a ptaka
    birdSprite = pygame.sprite.RenderClear() 
    bird = Bird()                       
    birdSprite.add(bird)

    #stworzenie Sprite'a dla dolnych słupków
    bottomPolesSprites = pygame.sprite.RenderClear()
    bottomPolesSprites.add(BottomPole(850))

    #stworzenie Sprite'a dla górnych słupków
    topPolesSprites = pygame.sprite.RenderClear()
    topPolesSprites.add(TopPole(-120))

    #stworzenie Sprite'a dla krawędzi ekranu
    edgesSprites = pygame.sprite.RenderClear()
    edgesSprites.add(Edge(-SCREEN_HEIGHT*0.5-20))
    edgesSprites.add(Edge(SCREEN_HEIGHT*1.5+15))

    #stworzenie Sprite'a licznika punktów
    scoreboardSprite = pygame.sprite.RenderClear()
    scoreboard=ScoreBoard()
    scoreboardSprite.add(scoreboard)

    #stworzenie Sprite'a licznika żyć
    lifesSprite = pygame.sprite.RenderClear()
    lifes=Lifes()
    lifesSprite.add(lifes)

    #załadowanie potrzebnych dźwięków
    birdFX = loadSound("trzepot.wav")
    lostFX = loadSound("przegrana.wav")
    hitFX = loadSound("rura.wav")

    prerunning = True
    running = True
    PolesCounter=0
    clock = pygame.time.Clock()

    #pętla początkowa kończy się po kliknięciu spacji, potem uruchamia się właściwa pętla gry
    while prerunning:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == KEYDOWN:
                if event.key == K_SPACE:
                    birdFX.play()
                    bird.motion = 1
                    bird.time()
                    prerunning = False
        
        birdSprite.update()
        birdSprite.clear(screen, background_image)
        birdSprite.draw(screen)
        pygame.display.flip()

    #właściwa pętla gry
    while running:
        clock.tick(40)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == KEYDOWN:
                if event.key == K_SPACE:
                    birdFX.play()
                    bird.motion = 1
                    bird.time()
                    

        PolesCounter += 1
        if PolesCounter >= 100:
            rand = random.randrange(-200,200)
            bottomPolesSprites.add(BottomPole(rand+850))
            topPolesSprites.add(TopPole(rand-120))
            PolesCounter = 0       


                     
        #aktualizacja wszystkich sprite'ów
        birdSprite.update()
        bottomPolesSprites.update()
        topPolesSprites.update()
        scoreboardSprite.update()
        lifesSprite.update()

        #zderzenie ptaka ze słupkiem przerwya grę i zapisuje wynik do pliku, chyba że gracz ma jeszcze życia - wtedy gra się toczy dalej, a licznik żyć się zmniejsza
        for hit in pygame.sprite.groupcollide(topPolesSprites,birdSprite,0,0):
            if lifes.counter == 1:
                file=open("wynikiŁatwy.txt",'a')
                file.write(str(scoreboard.score)+"\n")
                file.close()
                lostFX.play()
                time.sleep(0.5)
                lose(str(scoreboard.score), True)
                running = False
            else:
                lifes.decrease()
                hitFX.play()
                for hit in pygame.sprite.groupcollide(topPolesSprites,birdSprite,1,0):
                    pass

        #zderzenie ptaka ze słupkiem przerwya grę i zapisuje wynik do pliku, chyba że gracz ma jeszcze życia - wtedy gra się toczy dalej, a licznik żyć się zmniejsza
        for hit in pygame.sprite.groupcollide(bottomPolesSprites,birdSprite,0,0):
            if lifes.counter == 1:
                file=open("wynikiŁatwy.txt",'a')
                file.write(str(scoreboard.score)+"\n")
                file.close()
                lostFX.play()
                time.sleep(0.5)
                lose(str(scoreboard.score), True)
                running = False
            else:
                lifes.decrease()
                hitFX.play()
                for hit in pygame.sprite.groupcollide(bottomPolesSprites,birdSprite,1,0):
                    pass

        for hit in pygame.sprite.groupcollide(topPolesSprites,scoreboardSprite,0,0):
            pass

        for hit in pygame.sprite.groupcollide(topPolesSprites,edgesSprites,0,0):
            pass

        for hit in pygame.sprite.groupcollide(bottomPolesSprites,edgesSprites,0,0):
            pass

        #w łatwym trybie zderzenie z krawędzią ekranu nie sprawia, że gracz przegrywa
        for hit in pygame.sprite.groupcollide(birdSprite,edgesSprites,0,0):
            birdSprite.update(True)

        #czyszczenie ekranu
        birdSprite.clear(screen, background_image)
        bottomPolesSprites.clear(screen, background_image)
        topPolesSprites.clear(screen, background_image)
        scoreboardSprite.clear(screen, background_image)
        edgesSprites.clear(screen, background_image)
        lifesSprite.clear(screen, background_image)

        #rysowanie sprite'ów
        birdSprite.draw(screen)
        bottomPolesSprites.draw(screen)
        topPolesSprites.draw(screen)
        scoreboardSprite.draw(screen)
        edgesSprites.draw(screen)
        lifesSprite.draw(screen)
                
        pygame.display.flip()

#def funkcji, która otwiera okno z najlepszymi wynikami
def highscore():
    running = True
    #pętla okna
    while running:
        screen.fill((154,217,234))

        mx, my = pygame.mouse.get_pos()        

        #pobiera wyniki trybu HARD i wybiera 5 najlepszych        
        file=open("wyniki.txt",'r')
        scores=[]
        for line in file:
            scores.append(int(line[:-1]))
        file.close()
        scores.sort()
        scores.reverse()
        if len(scores)<5:
            for i in range(5-len(scores)):
                scores.append("")

        #pobiera wyniki trybu EASY i wybiera 5 najlepszych
        file=open("wynikiŁatwy.txt",'r')
        easyscores=[]
        for line in file:
            easyscores.append(int(line[:-1]))
        file.close()
        easyscores.sort()
        easyscores.reverse()
        if len(easyscores)<5:
            for i in range(5-len(easyscores)):
                easyscores.append("")
            

        button= pygame.Rect(200,500,200,50)
        
        pygame.draw.rect(screen, (255,0,0), button)

        Text("highscores",300,75)
        Text("HARD",410,145)
        Text("1. "+str(scores[0]),410,205)
        Text("2. "+str(scores[1]),410,265)
        Text("3. "+str(scores[2]),410,325)
        Text("4. "+str(scores[3]),410,385)
        Text("5. "+str(scores[4]),410,445)
        Text("wróć",300,525)
        Text("EASY",190,145)
        Text("1. "+str(easyscores[0]),190,205)
        Text("2. "+str(easyscores[1]),190,265)
        Text("3. "+str(easyscores[2]),190,325)
        Text("4. "+str(easyscores[3]),190,385)
        Text("5. "+str(easyscores[4]),190,445)
        Text("wróć",300,525)
        
        if button.collidepoint((mx,my)):
            if click:
                running = False


        click = False

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == MOUSEBUTTONDOWN:
                if event.button == 1:
                    click = True
                    
        pygame.display.flip()

#def funkcji, która otwiera okno z zasadami
def rulls():
    running = True
    while running:
        screen.fill((154,217,234))

        mx, my = pygame.mouse.get_pos()

        button= pygame.Rect(200,500,200,50)
        
        pygame.draw.rect(screen, (255,0,0), button)

        Text("Zasady",300,75)
        Text("Naciśnij spacje |____|",300,135)
        Text("by zacząć grę. Używaj spacji",300,195)
        Text("by sterować ptaszkiem.",300,255)
        Text("Kieruj nim tak, by przelatywał",300,315)
        Text("pomiędzy rurami. Powodzenia!",300,375)
        Text("wróć",300,525)

        if button.collidepoint((mx,my)):
            if click:
                running = False


        click = False

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == MOUSEBUTTONDOWN:
                if event.button == 1:
                    click = True
                    
        pygame.display.flip()

#def funkcji, która otwiera okno z informacjami o autorze
def author():
    running = True
    while running:
        screen.fill((154,217,234))

        mx, my = pygame.mouse.get_pos()

        button= pygame.Rect(200,500,200,50)
        
        pygame.draw.rect(screen, (255,0,0), button)

        Text("O autorze",300,75)
        Text("autor: Konrad Górski",300,135)
        Text("Gra wykonana",300,195)
        Text("na zajęcia z programowania.",300,255)
        Text("05.06.2020.",300,315)
        
        Text("wróć",300,525)

        if button.collidepoint((mx,my)):
            if click:
                running = False


        click = False

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == MOUSEBUTTONDOWN:
                if event.button == 1:
                    click = True
                    
        pygame.display.flip()

#def funkcji, która otwiera okno po przegraniu gry
#można zagrać jeszcze raz, albo wrócić do menu
def lose(score,avg=False):
    running = True
    while running:
        screen.fill((154,217,234))

        mx, my = pygame.mouse.get_pos()

        button1= pygame.Rect(120,440,360,50)
        button2= pygame.Rect(200,500,200,50)
        
        pygame.draw.rect(screen, (255,0,0), button1)
        pygame.draw.rect(screen, (255,0,0), button2)

        Text("GAME OVER, twój wynik to: "+score,300,75)
        Text("Zagraj jeszcze raz",300,465)
        Text("Menu",300,525)

        click = False

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == MOUSEBUTTONDOWN:
                if event.button == 1:
                    click = True

        if button2.collidepoint((mx,my)):
            if click:
                running = False
        elif button1.collidepoint((mx,my)):
            if click:
                if avg:
                    easygame()
                    running = False
                else:
                    game()
                    running = False
        pygame.display.flip()

#właściwy program to tylko uruchomienie funkcji menu()
pygame.init()
screen = pygame.display.set_mode((SCREEN_WIDTH,SCREEN_HEIGHT))

menu()
