%%Import a Word List
%% Import the data
[~, ~, WordleWords] = xlsread('\\files\home\My Documents\MATLAB\Matlab Intro\WordleWords.xlsx','Sheet1','A1:A12947');

WordleWords = string(WordleWords);
WordleWords(ismissing(WordleWords)) = '';
%Have Matlab read your excel file of words and turn each cell input to a
%string.

%% Display Welcome Messages
%Welcome Messages
disp(' Welcome to Wordle')
disp('You have 6 tries to guess the word.')
    disp('If you guess the correct letter in the correct spot, a green square will appear.')
    disp('If the letter is in the word but not in the correct spot, the square will be yellow.')
    disp('If the letter is not in the word, a black square will be shown.')
    
%% Generate a Random Word from Word List
randiword = WordleWords(randi(2315),1);
w = num2cell(char(randiword));
%Generating a random word from your list will help the game be different
%each time you play. Then, break the word down into it's individual
%letters.

%% Create a Function to Check a Guess
%In this function t is your guess variable, w is your randiword, l is the
%the letter you want to check ( 3 for third letter in word). The other
%variables of a,b,c,d are the other letters that you are not checking. If
%you are checking your third letter, for example, your a,b,c,d would be
%1,2,4,5. 

function y = Check(t,w,l,a,b,c,d) %create function to check each letter
g = num2cell(char(lower(t))); %break guessed word into letters
w = num2cell(char(w)); %break the random word into letters

%set points to make squares
x = [-1,1,1,-1,-1];
y = [0,0,1,1,0];

if g{l} == w{l} %if the second letter is correct
    
    %Make green square
    
    subplot(6,5,l) %set as subplot in correcsponding place
    fill(x,y,'-g') %fill green
    axis('square') %make square
    set(gca,'XTickLabel',[],'YTickLabel',[]) %remove axis labels
    title(g{l}) %set title as letter
    
elseif g{l} == w{a} || g{l} == w{b} ||g{l} == w{c} || g{l}==w{d} %if the letter appears somewhere else in word
    
    %make yellow square
    subplot(6,5,l) %set as subplot in corresponding place
    fill(x,y,'-y')%set fill to yellow
    axis('square') %make square
    set(gca,'XTickLabel',[],'YTickLabel',[]) %remove axis labels
    title(g{l}) %set title as letter
    
elseif g{l} ~= w{l} && g{l} ~= w{a} && g{l} ~= w{b} && g{l}~= w{c} && g{l} ~= w{d} %if the letter is not in the word
    
    %Make black square
    subplot(6,5,l) %set as subplot in corresponding place
    fill(x,y,'-k') %set fill to black
    axis('square') %make square
    set(gca,'XTickLabel',[],'YTickLabel',[]) %remove axis labels
    title(g{l})%set title as letter
    
   
    %% Create a Function to Check The Entire Word
    function checkword(t,w)
g = num2cell(char(t));
w = num2cell(char(w));

if g{1}==w{1} && g{2} == w{2} && g{3}==w{3} && g{4}==w{4} && g{5}==w{5}
   error('You have guessed the correct word! Congrats!')
  
else
   return
end
    end
% Use a function where t is your guess variable and w is your random word
% variable. Have the function break the guess and random word into
% individual characters and test if all of the letters are in the correct
% place. If they are, end the game with an error. If the word is not
% correct, return the user to guess again.
    %% Ask The User to Guess and Check 
    guess1 = inputdlg('Enter your guess','Guess 1');

%Check first letter of guess

    Check(guess1,randiword,1,2,3,4,5);

%Check second letter of guess

    Check(guess1,randiword,2,1,3,4,5);

%Check third letter of guess

    Check(guess1,randiword,3,1,2,4,5);

%Check fourth letter of guess

    Check(guess1,randiword,4,1,2,3,5);

%Check fifth letter of guess

    Check(guess1,randiword,5,1,2,3,4);


%Check the entire word
    checkword(guess1,randiword)
    
    %% Using the 6 Guesses Option
   %If you would like your user to be able to guess 6 times like the New
   %York Times game, reuse the code you have created asking for a guess,
   %checking each letter, and check the entire word each time. Using
   %Matlab's Run and Advance Option will allow users time to see the
   %results of their last guess. When having multiple guesses, you will
   %also have to adjust your subplots to be in the correct place. For
   %example, for your second guess you can reuse your check function to make subplots with :
   subplot(6,5,l+5)
   
