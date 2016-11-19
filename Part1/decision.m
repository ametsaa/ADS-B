function [ an ] = decision( rln )
% Simulation du block decision
    len=length(rln);
    an=zeros(1,len);
    for i=1:len
        if rln(i)<0
            an(i)=-1;
        else
            an(i)=1;
        end
    end

end

