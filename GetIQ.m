function [Ch_I, Ch_Q] = GetIQ(IQ, start_gate, end_gate, channel)  % Valid data is available only from Gate 2 to Gate 87
I_index_start = (start_gate-1)*6 + (channel-1)*2 +1;
Q_index_start = (start_gate-1)*6 + (channel-1)*2 +2;
I_index_end = (end_gate-1)*6 + (channel-1)*2 +1;
Q_index_end = (end_gate-1)*6 + (channel-1)*2 +2;
index_num = end_gate - start_gate + 1;
Channel_I_index = linspace(I_index_start,I_index_end,index_num);
Channel_Q_index = linspace(Q_index_start,Q_index_end,index_num);
Ch_I = IQ(Channel_I_index,:);
Ch_Q = IQ(Channel_Q_index,:);
end