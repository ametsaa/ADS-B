function [ bk ] = decision_bk( rln )
    len=length(rln);
    bk=zeros(1,len);
    for i=1:len
        if rln(i)<0
            bk(i)=1;
        else
            bk(i)=0;
        end
    end

end

