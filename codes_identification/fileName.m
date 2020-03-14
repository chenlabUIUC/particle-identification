function S = fileName(filename,n,ext)
% Returns the name of each specific frame with index n
% the No. n frame.
% HISTORY: modified by zihao, 20170530, include extension
        S2 = int2str(n);    [~,c] = size(S2);
        if c == 1
            S1 = ['_' '000' S2];
        elseif c == 2
            S1 = ['_' '00' S2];
        elseif c == 3
            S1 = ['_' '0' S2];
        end
        S = [filename S1 ext];
end