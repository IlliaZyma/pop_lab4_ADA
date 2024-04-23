with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Semaphores; use GNAT.Semaphores;

procedure Dinner_Philosophers is
   task type Phylosopher is
      entry Start(Id : Integer);
   end Phylosopher;

   Forks : array (1..5) of Counting_Semaphore(1, Default_Ceiling);

   task body Phylosopher is
      Id : Integer;
      Retry_Delay : constant := 0.1;
      Id_Left_Fork, Id_Right_Fork : Integer;
   begin
      accept Start (Id : in Integer) do
         Phylosopher.Id := Id;
      end Start;
      Id_Left_Fork := Id;
      Id_Right_Fork := Id rem 5 + 1;

      --Put_Line(Id'Img & " - " & Id_Left_Fork'Img & ", " & Id_Right_Fork'Img);

      for I in 1..10 loop
         Put_Line("Phylosopher " & Id'Img & " thinking " & I'Img & " time");

         if Forks(Id_Left_Fork).Value = 1 and then Forks(Id_Right_Fork).Value = 1 then
            Forks(Id_Left_Fork).Seize;
            Put_Line("Phylosopher " & Id'Img & " took left fork");

            Forks(Id_Right_Fork).Seize;
            Put_Line("Phylosopher " & Id'Img & " took right fork");

            Put_Line("Phylosopher " & Id'Img & " eating" & I'Img & " time");

            Forks(Id_Right_Fork).Release;
            Put_Line("Phylosopher " & Id'Img & " put right fork");

            Forks(Id_Left_Fork).Release;
            Put_Line("Phylosopher " & Id'Img & " put left fork");
         else loop
               if Forks(Id_Left_Fork).Value = 0 and then Forks(Id_Right_Fork).Value = 0 then
                  Put_Line("Phylosopher " & Id'Img & " waiting");
                  delay Retry_Delay;
               else
                  exit;
               end if;
            end loop;
         end if;
      end loop;
   end Phylosopher;

   Phylosophers : array (1..5) of Phylosopher;
Begin
   for I in Phylosophers'Range loop
      Phylosophers(I).Start(I);
   end loop;

end Dinner_Philosophers;
