require 'pry'

class Board

    attr_accessor :leg_values, :board_values   

    def initialize                                                  #on a besoin d'un plateau... avec des valeurs...
        @leg_values = ["1", "2", "3", "4", "5", "6", "7", "8", "9"] #qui nous servent de légende pour que le joueur positionne sont choix
        @board_values = Array.new(9, " ")                           #stockées dans un nouvel array qui va nous servir à positionner nos "X" et "O"
    end

    def draw_me_a_board(final_value)                                #ce plateau il faut le dessiner
        puts  "+---+---+---+"
        puts  "| #{final_value[0]} | #{final_value[1]} | #{final_value[2]} |"
        puts  "+---+---+---+"
        puts  "| #{final_value[3]} | #{final_value[4]} | #{final_value[5]} |"
        puts  "+---+---+---+"
        puts  "| #{final_value[6]} | #{final_value[7]} | #{final_value[8]} |"
        puts  "+---+---+---+"
    end

    def update_it(took, location)                                   #et le mettre à jour à chaque tour avec le symbole choisi des joueurs
        @board_values[location -1] = took
    end

end

class Player                                                        #il nous faut définir une classe joueur qui comporte
    attr_accessor :name, :took, :case_chosen

    def initialize(name, took)
        @name = name                                                 #un nom
        @took = took                                                 #le symbole choisit par le joueur
        @case_chosen = []                                            #et les cases qu'il a choisies
    end

    def add_the_pick(number_case)
        @case_chosen.push(number_case)                               #chaque case choisie par le joueur est "pushée" dans l'array correspondant
    end
end


class Game                                                          #il faut définir une classe Game qui va lancer tout le déroulé du jeu
                                                                    #qui va comporter
    attr_reader :player1, :player2, :current_player, :board

    def initialize                                                  
        @selected_took = nil                                         #le choix du joueur, vide au départ
        @player1 = start_player("player1")                           #un joueur1 auquel on va appliquer l'écran de démarrage
        @player2 = start_player("player2")                           #un jouer2 idem
        @board = Board.new                                           #un plateau qui sera l'instance de la classe plateau
        @current_player = @player1                                   #et enfin il faut déterminer quel joueur "joue" à l'instant "t". On commence avec le jouer 1
    end

    def play_turn                                                    
        location = get_location()                                    #la place est récupérée par cette def
        board.update_it(current_player.took, location)               #on applique la MAJ
        current_player.add_the_pick(location)                        #on push la localisation dans l'array du joueur
    end

    def appears
        puts
        puts "LÉGENDE:"
        @board.draw_me_a_board(@board.leg_values)
        puts "Sers-toi de la légende pour choisir ta case !"
        puts
        puts "Tic Tac Toe"
        @board.draw_me_a_board(@board.board_values)
        puts
    end

    def switch_this_player                                          #il faut changer de joueur après chaque action. Donc si le joueur actuel est 
        @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
    end                                                             #le joueur1, on passe au suivant et inversement

    def victory?                                                    #cet array détermine les 8 conditions de victoires existantes au jeu du morpion
    it_s_win = [[1,2,3], [4,5,6], [7,8,9],
                [1,4,7], [2,5,8], [3,6,9],
                [1,5,9], [3,5,7]]

    it_s_win.each do |condition|                                    #à chacun de ces array dans l'array, on vérifie...
        if (condition - current_player.case_chosen).empty?          #qu'une des conditions n'est pas égale à l'array d'un des joueurs
            puts "#{current_player.name} remporte !"
            return true
            end
        end
        
        if  board.board_values.none? {|value| value == " "}         #s'il ne reste plus aucune valeur avec espace, alors il y a égalité
            puts "Malheureusement, il n'y a pas de gagnants !"
            return true
            end
            false
        end

    private

    def start_player(player)                                        #au démarrage, chaque joueur va avoir différentes actions
        player_name = get_this_name(player)                         #choisir son nom
        player_choice = get_choice(player_name)                     #choisir son symbole
        Player.new(player_name, player_choice)                      #ainsi chaque joueur répondra à ces 2 critères
    end

    def get_this_name(player)
        puts "#{player} entrez votre nom !"
        print ">"
        gets.chomp
    end

    def get_choice(player_name)
        if @selected_took.nil?                                        #au démarrage, il n'y a encore aucune choix de fait, et l'animation
            puts "Bienvenue #{player_name} ! Que choisis-tu, 'X' ou 'O' ?"
            took = gets.chomp.upcase
            while took != 'X' && took != 'O'                          #on fait bien attention à récuper les bons symboles
                puts "Et si tu entrais plutôt un 'X' ou un 'Y' ?"
                took = gets.chomp.upcase
            end
            @selected_took = took
        else 
            took = @selected_took == "X" ? "O" : "X"
            puts "Pour toi #{player_name}, ce sera '#{took}'"
        end
        took
    end

    def get_location
        puts "#{current_player.name}, c'est ton tour ! Que choisis-tu ?"
        location = gets.chomp.to_i
        until location.between?(1, 9) && @board.board_values[location - 1]
            unless location.between?(1, 9)
                puts "Il faut sélectionner un chiffre de 1 à 9, pas autre chose ! Try again ?"
                location = gets.chomp.to_i
            end
            unless @board.board_values[location - 1] == " "
                puts "Ah bah non ! Cette case a déjà été choisie ! Sélectionne un autre chiffre !"
                location = gets.chomp.to_i
            end
        end
        location
    end

end

game = Game.new()
game.switch_this_player
game.appears
until game.victory?
    game.switch_this_player
    game.play_turn
    game.appears
end