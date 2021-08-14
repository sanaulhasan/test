
resource "aws_vpc" "app" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-app-node"
  )
}

resource "aws_subnet" "app" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.app.id

  tags = map(
    "Name", "terraform-eks-app-node"
  )
}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id

  tags = {
    Name = "terraform-eks-app"
  }
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }
}

resource "aws_route_table_association" "app" {
  count = 2

  subnet_id      = aws_subnet.app.*.id[count.index]
  route_table_id = aws_route_table.app.id
}
