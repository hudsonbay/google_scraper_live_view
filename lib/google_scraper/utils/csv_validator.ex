defmodule CSVOperations do
  @keyword_limit 100

  def provide_valid_csv(file) do
    file
    |> read_csv()
    |> validate_limit()
    |> validate_duplicated_keywords()
  end

  defp read_csv(file) do
    content =
      file
      |> File.stream!()
      |> CSV.decode!()
      |> Enum.map(& &1)
      |> List.flatten()

    %{"csv" => content, "errors" => []}
  end

  defp validate_limit(%{"csv" => content, "errors" => errors}) do
    case Enum.count(content) < @keyword_limit do
      true ->
        %{"csv" => content, "errors" => errors}

      false ->
        %{"csv" => content, "errors" => ["more than 100 keywords" | errors]}
    end
  end

  defp validate_duplicated_keywords(%{"csv" => content, "errors" => errors}) do
    content
    |> Enum.reduce_while(%MapSet{}, fn x, acc ->
      if MapSet.member?(acc, x), do: {:halt, false}, else: {:cont, MapSet.put(acc, x)}
    end)
    |> is_boolean()
    |> case do
      true -> %{"csv" => content, "errors" => ["duplicated keywords" | errors]}
      false -> %{"csv" => content, "errors" => errors}
    end
  end

  def format_csv_errors(errors) do
    Enum.join(errors, ", ")
  end
end
